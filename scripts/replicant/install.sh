#!/bin/sh
#

ROOT_DIR=$(git rev-parse --show-toplevel)

# Get Composer and install dependencies
mkdir ${ROOT_DIR}/bin
curl -sS https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer
bin/composer install --prefer-dist

# Install Drupal
cd ${ROOT_DIR}/web
${ROOT_DIR}/bin/drush site-install minimal --db-url=mysql://root:strife49@127.0.0.1/database -y

# Setup configuration
chmod 777 ${ROOT_DIR}/web/sites/default/settings.php
echo -e "\$config_directories['staging'] = '../configuration';" >> ${ROOT_DIR}/web/sites/default/settings.php
chmod 666 ${ROOT_DIR}/web/sites/default/settings.php

# Import Drupal configuration
${ROOT_DIR}/bin/drush config-set system.site uuid 201ca0e3-75d8-46da-9500-dea2d26dbb72 -y
${ROOT_DIR}/bin/drush config-import -y
