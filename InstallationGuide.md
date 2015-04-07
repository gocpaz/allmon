# Installation #

## Introduction ##

  * Download the latest allmon release zip (allmon-0.x.x.zip) - http://code.google.com/p/allmon/downloads/list
  * Download Active MQ (5.2) - http://activemq.apache.org/activemq-520-release.html
  * Ensure that your JAVA\_HOME and ANT\_HOME environment variables are set properly

## Database ##

### Oracle ###

  * Create a new schema (recommended user "allmon")
  * Execute [allmon-0.x.x.zip]/allmon-db/oracle/create-allmon-schema.sql (creates schema and all necessary packages)

### PostgreSQL ###

  * Sorry, not supported yet!

## Server-side ##

  * Install downloaded Active MQ on client machine or in "close" neighbourhood (requires previous ant installation)
  * Unzip and copy [allmon-0.x.x.zip]/allmon-server directory to your allmon server location
  * Configure connection to database by editing /allmon-server/conf/allmon.properties file entries:
    * allmon.server.db.url = jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=...)(PORT=1521))(CONNECT\_DATA=(SERVER=dedicated)(SERVICE\_NAME=...)))
    * allmon.server.db.username = allmon
    * allmon.server.db.password = ...
  * Execute /allmon-server/bin/allmon-server.bat

## Client-side ##

(it can be also on the same machine which you use as a allmon server)

  * Install downloaded Active MQ on client machine or in "close"  (requires previous ant installation)
  * Unzip and copy [allmon-0.x.x.zip]/allmon-client directory to your client location
  * Execute /allmon-client/bin/allmon-client.bat

# Additional configuration #

## Server-side ##

  * TODO

## Client-side ##

  * TODO