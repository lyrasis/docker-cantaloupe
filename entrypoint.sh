#!/bin/bash

# Create Cantaloupe User
groupadd -r -g $CANTALOUPE_GID cantaloupe
useradd -r -s /bin/false -g cantaloupe -u $CANTALOUPE_UID cantaloupe

# Make sure permissions are good
chown -R cantaloupe:cantaloupe /cantaloupe

# Template configuration files
/usr/local/bin/confd -onetime -backend env

# Correct permissions on /dev/stdout before we drop privledges
chown cantaloupe:cantaloupe /dev/stdout

gosu cantaloupe:cantaloupe java -cp /cantaloupe/lib/mysql-connector.jar:/cantaloupe/cantaloupe.war -Dcantaloupe.config=$PROPERTIES_FILE $JAVA_OPTS edu.illinois.library.cantaloupe.StandaloneEntry
