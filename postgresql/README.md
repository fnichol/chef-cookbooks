Description
===========

Installs and configures PostgreSQL as a client or a server.

Changes/Roadmap
==============

## v 0.99.0

* Better support for Red Hat-family platforms
* Integration with database cookbook
* Make sure the postgres role is updated with a (secure) password

Requirements
============

## Platforms

* Debian, Ubuntu
* Red Hat/CentOS/Scientific (6.0+ required) - "EL6-family"
* Fedora
* SUSE

Tested on:

* Ubuntu 10.04, 11.10
* Red Hat 6.1, Scientific 6.1

## Cookboooks

Requires Opscode's `openssl` cookbook for secure password generation.

Requires a C compiler and development headers in order to build the
`pg` RubyGem to provide Ruby bindings so they're available in other
cookbooks.

Opscode's `build-essential` cookbook provides this functionality on
Debian, Ubuntu, and EL6-family.

While not required, Opscode's `database` cookbook contains resources
and providers that can interact with a PostgreSQL database. This
cookbook is a dependency of that one.

Attributes
==========

The following attributes are set based on the platform, see the
`attributes/default.rb` file for default values.

* `node['postgresql']['version']` - version of postgresql to manage
* `node['postgresql']['dir']` - home directory of where postgresql
  data and configuration lives.

The following attributes are generated in
`recipe[postgresql::server]`.

* `node['postgresql']['password']['postgres']` - randomly generated
  password by the `openssl` cookbook's library.
* `node['postgresql']['ssl']` - whether to enable SSL (off for version
  8.3, true for 8.4).


Basic configuration 

* `node[:postgresql][:listen_address]` - default to localhost
* `node[:postgresql][:port]` - 5432

Commonly used performance tuning attributes

* `node[:postgresql][:tunable][:max_connections]` - Determines the maximum number of concurrent connections to the database server
* `node[:postgresql][:tunable][:shared_buffers]` - Sets the amount of memory the database server uses for shared memory buffers.
* `node[:postgresql][:tunable][:effective_cache_size]` - Sets the planner's assumption about the effective size of the disk cache that is available to a single query.
* `node[:postgresql][:tunable][:work_mem]` - Specifies the amount of memory to be used by internal sort operations and hash tables before writing to temporary disk files. 
* `node[:postgresql][:tunable][:synchronous_commit]` - Specifies whether transaction commit will wait for WAL records to be written to disk before the command returns a "success" indication to the client.
* `node[:postgresql][:tunable][:wal_buffer]` - The amount of shared memory used for WAL data that has not yet been written to disk.
* `node[:postgresql][:tunable][:wal_sync_method]` - Method used for forcing WAL updates out to disk.
* `node[:postgresql][:tunable][:checkpoint_segments]` Maximum number of log file segments between automatic WAL checkpoints (each segment is normally 16 megabytes).
* `node[:postgresql][:tunable][:checkpoint_timeout]` - Maximum time between automatic WAL checkpoints, in seconds.
* `node[:postgresql][:tunable][:checkpoint_completion_target]` - Specifies the target of checkpoint completion, as a fraction of total time between checkpoints.

Default values match those provided by Postgresql. For tuning, please, referer to [PgSQL Wiki](http://wiki.postgresql.org/wiki/Performance_Optimization) or [Postgresql 9.0 High Performance Guide](http://www.2ndquadrant.com/en/postgresql-90-high-performance/).

Recipes
=======

default
-------

Includes the client recipe.

client
------

Installs postgresql client packages and development headers during the
compile phase. Also installs the `pg` Ruby gem during the compile
phase so it can be made available for the `database` cookbook's
resources, providers and libraries.

server
------

Includes the `server_debian` or `server_redhat` recipe to get the
appropriate server packages installed and service managed. Also
manages the configuration for the server:

* generates a strong default password (via `openssl`) for `postgres`
* sets the password for postgres
* manages the `pg_hba.conf` file.

server\_debian
--------------

Installs the postgresql server packages, manages the postgresql
service and the postgresql.conf file.

server\_redhat
--------------

Manages the postgres user and group (with UID/GID 26, per RHEL package
conventions), installs the postgresql server packages, initializes the
database and manages the postgresql service, and manages the
postgresql.conf file.

Resources/Providers
===================

See the [database](http://community.opscode.com/cookbooks/database)
for resources and providers that can be used for managing PostgreSQL
users and databases.

Usage
=====

On systems that need to connect to a PostgreSQL database, add to a run
list `recipe[postgresql]` or `recipe[postgresql::client]`.

This does install the `pg` RubyGem, which has native C extensions, so
that the resources and providers can be used in the `database`
cookbook, or elsewhere in the same Chef run. Use Opscode's
`build-essential` cookbook to make sure the proper build tools are
installed so the C extensions can be compiled.

On systems that should be PostgreSQL servers, use
`recipe[postgresql::server]` on a run list. This recipe does set a
password and expect to use it. It performs a node.save when Chef is
not running in `solo` mode. If you're using `chef-solo`, you'll need
to set the attribute `node['postgresql']['password']['postgres']` in
your node's `json_attribs` file or in a role.

License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Lamont Granquist (<lamont@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
