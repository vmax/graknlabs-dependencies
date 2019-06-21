#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

def _deploy_npm_impl(ctx):
    preprocessed_deploy_script = ctx.actions.declare_file('_deploy.sh')

    ctx.actions.expand_template(
        output = preprocessed_deploy_script,
        template = ctx.file._deployment_script_template,
        substitutions = {
            "$BAZEL_PACKAGE_NAME": ctx.attr.target.label.package,
            "$BAZEL_TARGET_NAME": ctx.attr.target.label.name,
        }
    )

    ctx.actions.run_shell(
        inputs = [preprocessed_deploy_script, ctx.file.version_file],
        outputs = [ctx.outputs.deployment_script],
        command = "VERSION=`cat %s` && sed -e s/{version}/$VERSION/g %s > %s" % (
                    ctx.file.version_file.path, preprocessed_deploy_script.path, ctx.outputs.deployment_script.path)
    )

    return DefaultInfo(executable = ctx.outputs.deployment_script,
                       runfiles = ctx.runfiles(
                           files = ctx.files.target + ctx.files._node_runfiles + [ctx.file.deployment_properties],
                           symlinks = {
                               "deployment.properties": ctx.file.deployment_properties
                           }))

deploy_npm = rule(
    implementation = _deploy_npm_impl,
    attrs = {
        "target": attr.label(
            mandatory = True,
            doc = "`npm_library` label to be included in the package",
        ),
        "version_file": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "File containing version string"
        ),
        "deployment_properties": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "File containing Node repository url by `repo.npm` key"
        ),
        "_deployment_script_template": attr.label(
            allow_single_file = True,
            default = "//npm/templates:deploy.sh",
        ),
        "_node_runfiles": attr.label(
            default = Label("@nodejs//:node_runfiles"),
            allow_files = True
        )
    },
    executable = True,
    outputs = {
          "deployment_script": "%{name}.sh",
    },
    doc = "Deploy `npm_package` target into NPM repo"
)