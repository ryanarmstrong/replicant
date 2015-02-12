#!/bin/sh
#

ROOT_DIR=$(git rev-parse --show-toplevel)

# Use the correct autoloader in the core front controllers.
# See https://www.drupal.org/node/2406681
cd ${ROOT_DIR}/vendor/drupal/core
for FILE in "authorize.php" "install.php" "rebuild.php"
do
  sed -i "s/require_once\ __DIR__\ \.\ '\/vendor\/autoload\.php'\;/require_once\ __DIR__\ \.\ '\/..\/..\/vendor\/autoload\.php'\;/" $FILE
done

# Copy index.php from the upstream Drupal repository and modify to use the proper autoloader.
cd ${ROOT_DIR}/web
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/index.php
perl -pi -e 's/core/../g' index.php

# Get Drupal Console
curl -LSs http://drupalconsole.com/installer | php
mv console.phar ${ROOT_DIR}/bin/drupal

# Return to project root.
cd ${ROOT_DIR}
