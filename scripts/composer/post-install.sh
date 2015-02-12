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

# Download needed files that reside outside of Drupal core.
cd ${ROOT_DIR}/web
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.csslintrc
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.editorconfig
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.eslintignore
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.eslintrc
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.gitattributes
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/.htaccess
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/index.php
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/robots.txt
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/web.config

mkdir -p ${ROOT_DIR}/web/sites/default
cd ${ROOT_DIR}/web/sites/default
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/sites/default/default.services.yml
wget https://raw.githubusercontent.com/drupal/drupal/8.0.x/sites/default/default.settings.php

# Modify settings.php to use the correct configuration staging folder.
perl -pi -e 's/core/../g' ${ROOT_DIR}/web/index.php

# Get Drupal Console
curl -LSs http://drupalconsole.com/installer | php
mv console.phar ${ROOT_DIR}/bin/drupal

# Return to project root.
cd ${ROOT_DIR}
