#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

load("@graknlabs_bazel_distribution//common:rules.bzl", "assemble_targz")

exports_files(["deployment.properties"], visibility = ["//visibility:public"])

assemble_targz(
    name = "assemble-bash-targz",
    additional_files = {
        "//binary:grakn": 'grakn',
    },
    permissions = {
        "grakn": "0755",
    },
    visibility = ["//visibility:public"]
)

assemble_targz(
    name = "assemble-bat-targz",
    additional_files = {
        "//binary:grakn.bat": 'grakn.bat',
    },
    visibility = ["//visibility:public"]
)
