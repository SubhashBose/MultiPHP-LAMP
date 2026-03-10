FROM php:7.4-fpm-bullseye

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg62-turbo-dev libzip-dev \
    libcurl4-openssl-dev libbz2-dev libicu-dev \
    libonig-dev msmtp \
    && rm -rf /var/lib/apt/lists/*

# Bullseye requires explicit --with-jpeg flag for gd
RUN docker-php-ext-configure gd --with-jpeg

RUN docker-php-ext-install \
    bz2 gd intl mysqli pdo_mysql zip gettext
#    curl bz2 fileinfo gd gettext intl mbstring \
#    pdo mysqli pdo_mysql sqlite3 xml dom simplexml \
#    zip

# zz-docker.conf loads after www.conf (z > w) and overrides listen
RUN sed -i 's|^listen = .*|listen = /run/php/php7.4-fpm.sock|' /usr/local/etc/php-fpm.d/zz-docker.conf
# && sed -i 's|;listen.owner = www-data|listen.owner = www-data|' /usr/local/etc/php-fpm.d/www.conf \
# && sed -i 's|;listen.group = www-data|listen.group = www-data|' /usr/local/etc/php-fpm.d/www.conf \
# && sed -i 's|;listen.mode = 0660|listen.mode = 0660|' /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /run/php && chmod 777 /run/php

CMD ["php-fpm", "-F"]
