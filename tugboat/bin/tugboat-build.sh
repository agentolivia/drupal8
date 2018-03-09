#!/usr/bin/env bash
set -ex

cd ${TUGBOAT_ROOT}
composer install

cd ${TUGBOAT_ROOT}/web

drush site-install standard -y
#drush en devel -y

rm -Rf /tmp/*
