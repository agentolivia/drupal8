#!/usr/bin/env bash
set -ex

cd web
drush site-install standard -y
drush en devel -y

rm -Rf /tmp/*
