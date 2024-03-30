#!/bin/sh
set -e

# Verificar se o Drupal está instalado
if [ ! -f "/opt/drupal/web/index.php" ]; then
    echo "Installing Drupal ${DRUPAL_VERSION}..."

    composer create-project --no-interaction "drupal/recommended-project:${DRUPAL_VERSION}" /opt/drupal

    chown -R www-data:www-data /opt/drupal

    rmdir /var/www/html

    ln -sf /opt/drupal /var/www/html

fi

exec "$@"
