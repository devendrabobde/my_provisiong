OneStop
=========

Installation instructions for OS X 10.7+:
_This assumes a stock out-of-the-box installation_

1. Download and copy [Oracle Database Express Edition 11g Release 2](http://www.oracle.com/technetwork/database/express-edition/downloads/index.html) to
   `modules/oracle/files/oracle-xe-11.2.0-1.0.x86_64.rpm.zip`
2. Copy the downloaded Oracle Database file from step 1 and move into `PATH_TO_ONESTOP_PROJECT/modules/oracle/files/`
3. Download and copy
   [ojdbc6.jar](http://www.oracle.com/technetwork/database/enterprise-edition/jdbc-112010-090769.html)
to `lib/`
4. run `vagrant up`
5. Once vagrant has installed everything, perform the following:
```bash
vagrant ssh
rvm user all
cd /vagrant
rvm install jruby
jruby -S bundle
```

Create the Oracle development and test database users:
=================================================

1. Make sure we're allowed to modify the db:
```bash
sudo usermod -a -G dba vagrant
```
2. Login to sqlplus and create the development and test users:
```bash
cd /vagrant
cat modules/oracle/files/oracle_env.conf >> ~/.bashrc
. ~/.bashrc
sqlplus /nolog
```
```sql
CONNECT / AS SYSDBA
CREATE USER development IDENTIFIED BY password;
GRANT unlimited tablespace, create session, create table, create
sequence, create procedure, create trigger, create view, create
materialized view, create database link, create synonym, create type,
ctxapp TO development;
CREATE USER test IDENTIFIED BY test;
GRANT unlimited tablespace, create session, create table, create
sequence, create procedure, create trigger, create view, create
materialized view, create database link, create synonym, create type,
ctxapp TO test;
QUIT
```
3. Setup the database
```bash
bundle exec rake db:setup
```
4. Run the test suite
```base
bundle exec rake
```

Loading the performance data
=====================================
1. Copy the performance.dmp.gz file to '/tmp' and unzip:
```bash
$ cp /vagrant/doc/performance_test.jmeter/performance.dmp.gz /tmp
$ cd /tmp && gunzip performance.dmp.gz
```

2. Create a directory in the database
```bash
$ sqlplus /nolog
CONNECT / AS SYSDBA
CREATE DIRECTORY tmpdir AS '/tmp';
GRANT read,write ON DIRECTORY tmpdir TO test;
QUIT
```

3. Import the database to the test user
```bash
$ impdp test/test DIRECTORY=tmpdir DUMPFILE=performance.dmp
remap_schema=performance:test
```

Halting and restarting the VM:
=====================================

Halting:
`vagrant halt`

Restarting:
`vagrant reload --no-provision`

Starting the Oracle XE instance:
===================================

inside `vargant ssh` run:
`sudo /etc/init.d/oracle-xe start`

NOTE: if you're using OSX, or you are getting an empty prompt, you have to run `vagrant ssh -- -t -t` instead

Contact Nick (nhance@reenhanced.com) if you have any issues with this process.
