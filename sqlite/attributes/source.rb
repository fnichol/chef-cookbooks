#
# Cookbook Name:: sqlite
# Attributes:: source
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:sqlite][:url]      = "http://www.sqlite.org"
default[:sqlite][:version]  = "3070500"
default[:sqlite][:checksum] = "cb5b86926ec9f65882b2dddd244f2d620337d911ec73411863f77e48cf6a2f94"

default[:sqlite][:configure_options]  = []
