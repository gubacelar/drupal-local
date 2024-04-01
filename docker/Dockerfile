FROM php:8.2-fpm-alpine3.19

# Install necessary packages and PHP extensions
RUN set -eux; \
    apk add --no-cache --virtual .build-deps \
        coreutils \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        postgresql-dev \
    ; \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg=/usr/include \
        --with-webp \
    ; \
    docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        zip \
    ; \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --no-network --virtual .drupal-phpexts-rundeps $runDeps; \
    apk del --no-network .build-deps

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

ENV DRUPAL_VERSION 10.2.4
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install curl, bash, and nvm
RUN set -eux; \
    apk add --no-cache curl bash; \
    touch ~/.bashrc; \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash; \
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc; \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc; \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# Change the default shell to bash
SHELL ["/bin/bash", "-c"]

WORKDIR /opt/drupal

ENV PATH=${PATH}:/opt/drupal/vendor/bin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm"]
