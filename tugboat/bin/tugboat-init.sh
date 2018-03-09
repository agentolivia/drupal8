#!/usr/bin/env bash

# This is called during "tugboat init", after all of the service containers have
# been built, and the git repo has been cloned. This can be used for things like
# installing additional libraries that don't come built-in to the tugboat
# containers.

# Turn on error detection and xtracing. Helpful for debugging.
set -ex

# Change the webroot
ln -sf ${TUGBOAT_ROOT}/web /var/www/html


# Install some packages.
#LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install -y \
  rsync \
  wget \
  vim \
  zip \
  libjpeg-progs \
  optipng \
  imagemagick \
  php-pear \
  php7.1-curl \
  php7.1-gd \
  php7.1-imagick \
  php7.1-intl \
  php7.1-ldap \
  php7.1-mcrypt \
  php7.1-memcached \
  php7.1-mysql \
  php7.1-oauth \
  php7.1-dev \
  php7.1-xmlrpc \
  php7.1-xsl \
  php7.1-mbstring \
  libapache2-mod-php7.1

# Set up apache modules.
a2enmod headers

# Create the databases and import the sql file.
mysql --user=tugboat --password=tugboat --host=mysql \
  -e 'create database drupal8;'

# Create the public files directory and rsync files to it.
mkdir -p web/sites/default/files
chgrp -R www-data web/sites/default
chmod -R g+w web/sites/default/files
chmod 2775 web/sites/default/files

# Create the private files directory.
mkdir -p private/files
chgrp -R www-data private/files
chmod -R g+w private/files
chmod 2775 private/files

# Copy the Drupal settings file over.
cp tugboat/assets/settings.local.php web/sites/default

# Now run tugboat-update to get the db and files installed.
make tugboat-update

# Ensure drush is running
cd /usr/local/src/drush
composer install

# Clean up after ourselves.
rm -Rf /tmp/*
