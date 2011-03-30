#
# Cookbook Name:: sqlite
# Recipe:: source
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

include_recipe "build-essential"

cache_path  = Chef::Config[:file_cache_path]
version     = node[:sqlite][:version]
tarball     = "sqlite-autoconf-#{version}.tar.gz"

configure_opts = node[:sqlite][:configure_options].join(" ")

remote_file "#{cache_path}/#{tarball}" do
  source    "#{node[:sqlite][:url]}/#{tarball}"
  checksum  node[:sqlite][:checksum]
  mode      "0644"
end

bash "build sqlite" do
  cwd       cache_path
  code      <<-BUILD
    tar -zxf #{tarball}
    (cd sqlite-autoconf-#{version} && ./configure #{configure_opts})
    (cd sqlite-autoconf-#{version} && make && make install)
  BUILD
  not_if    { ::File.exists?("/usr/local/bin/sqlite3") }
end
