#!/bin/bash

MYSQL_LIB_VERSION=5.1.44
CANTALOUPE_VERSION=4.0
GOSU_VERSION=1.10
OPENJPEG_VERSION=2.3.0

export DEBIAN_FRONTEND=noninteractive
export TERM=linux

# Install some packages used for setup
apt-get update
apt-get install --yes --no-install-recommends apt-utils
apt-get install --yes --no-install-recommends unzip
apt-get install --yes --no-install-recommends wget

# Install some packages used by the application
apt-get install --yes --no-install-recommends ca-certificates
apt-get install --yes openjdk-8-jre-headless
apt-get install --yes --no-install-recommends imagemagick
apt-get install --yes --no-install-recommends ghostscript
apt-get install --yes --no-install-recommends libmagickcore-6.q16-2-extra
apt-get install --yes --no-install-recommends ffmpeg
apt-get install --yes --no-install-recommends graphicsmagick
apt-get install --yes --no-install-recommends curl

# Install confd
wget -q -O /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.10.0/confd-0.10.0-linux-amd64
chmod +x /usr/local/bin/confd
mkdir /etc/confd
mkdir /etc/confd/conf.d
mkdir /etc/confd/templates

# Install gosu
dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"
wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
chmod +x /usr/local/bin/gosu

# Create directories
mkdir /cantaloupe
mkdir /cantaloupe/lib
mkdir /cantaloupe/cache
mkdir /cantaloupe/logs
mkdir /cantaloupe/images

# Download Cantaloupe
wget -q http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_LIB_VERSION/mysql-connector-java-$MYSQL_LIB_VERSION.jar -O /cantaloupe/lib/mysql-connector.jar
wget -q https://github.com/medusa-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/Cantaloupe-$CANTALOUPE_VERSION.zip -O /cantaloupe/cantaloupe.zip
unzip /cantaloupe/cantaloupe.zip -d /cantaloupe
mv /cantaloupe/cantaloupe-$CANTALOUPE_VERSION/cantaloupe-$CANTALOUPE_VERSION.war /cantaloupe/cantaloupe.war
mv /cantaloupe/cantaloupe-$CANTALOUPE_VERSION/delegates.rb.sample /cantaloupe/delegates.rb
rm -Rf /cantaloupe/cantaloupe-$CANTALOUPE_VERSION
rm /cantaloupe/cantaloupe.zip

# Setup confd templates
mv /build/cantaloupe.toml /etc/confd/conf.d/cantaloupe.toml
mv /build/cantaloupe.properties /etc/confd/templates/cantaloupe.properties

# Download & Install KDU
wget -q http://kakadusoftware.com/wp-content/uploads/2014/06/KDU7A2_Demo_Apps_for_Ubuntu-x86-64_170827.zip -O /tmp/kdu.zip
unzip -q /tmp/kdu.zip -d /tmp
mv /tmp/KDU7A2_Demo_Apps_for_Ubuntu-x86-64_170827/kdu_* /bin
mv /tmp/KDU7A2_Demo_Apps_for_Ubuntu-x86-64_170827/*.so /lib
rm /tmp/kdu.zip
rm -Rf /tmp/KDU7A2_Demo_Apps_for_Ubuntu-x86-64_170827

# Download and install OpenJPEG
wget -q https://github.com/uclouvain/openjpeg/releases/download/v$OPENJPEG_VERSION/openjpeg-v$OPENJPEG_VERSION-linux-x86_64.tar.gz -O /tmp/openjpeg.tar.gz
tar -xzf /tmp/openjpeg.tar.gz -C /tmp
mv /tmp/openjpeg-v$OPENJPEG_VERSION-linux-x86_64/bin/* /bin
mv /tmp/openjpeg-v$OPENJPEG_VERSION-linux-x86_64/lib/* /lib
rm -Rf /tmp/openjpeg-v$OPENJPEG_VERSION-linux-x86_64
rm /tmp/openjpeg.tar.gz

# Clean up
apt-get purge -y --auto-remove unzip
apt-get purge -y --auto-remove wget
rm -rf /var/lib/apt/lists/*
