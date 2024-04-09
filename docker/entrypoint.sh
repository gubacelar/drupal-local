#!/bin/sh
set -e

# Directory where Drupal should be installed
DRUPAL_DIR="/opt/drupal"

# Check if the directory is empty
is_directory_empty() {
    [ -z "$(ls -A "$DRUPAL_DIR" 2>/dev/null)" ]
}

# Install Drupal if the directory is empty
if is_directory_empty; then
    echo "Directory $DRUPAL_DIR is empty. Installing Drupal ${DRUPAL_VERSION}..."
    composer create-project --no-interaction "drupal/recommended-project:${DRUPAL_VERSION}" $DRUPAL_DIR
else
    echo "Directory $DRUPAL_DIR is not empty. Checking for composer dependencies..."
    # Navigate to the Drupal directory and run composer install
    cd $DRUPAL_DIR
    composer install --no-interaction
fi

# Set file permissions
echo "Setting file permissions..."
chown -R www-data:www-data $DRUPAL_DIR

# Create a symbolic link for the web server, if necessary
if [ ! -L "/var/www/html" ]; then
    echo "Creating symbolic link for Drupal..."
    ln -sf $DRUPAL_DIR/web /var/www/html
    echo "Symbolic link created: /var/www/html -> $DRUPAL_DIR/web"
else
    echo "Symbolic link already exists."
fi

# Execute the command passed to the script
exec "$@"
