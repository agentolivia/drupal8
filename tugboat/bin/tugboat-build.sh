#!/usr/bin/env bash
set -ex

ln -sf ${TUGBOAT_ROOT}/web /var/www/html/web

cd web
drush site-install standard -y
drush en devel -y

rm -Rf /tmp/*
