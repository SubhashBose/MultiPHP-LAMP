FROM php:5.6-fpm-stretch

# Debian Stretch is EOL — redirect apt to archive and allow expired/missing keys
RUN sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g' /etc/apt/sources.list \
 && sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && sed -i '/stretch-updates/d' /etc/apt/sources.list \
 && apt-get \
      -o Acquire::Check-Valid-Until=false \
      -o Acquire::AllowInsecureRepositories=true \
      -o Acquire::AllowDowngradeToInsecureRepositories=true \
      update \
 && apt-get install -y --allow-unauthenticated \
      libpng-dev libjpeg62-turbo-dev libzip-dev libmcrypt-dev \
      libcurl4-openssl-dev libbz2-dev libicu-dev \
      libonig-dev msmtp \
 && rm -rf /var/lib/apt/lists/*

# Configure gd with jpeg support, then install extensions
# PHP 5.6 uses older gd flag syntax
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include

RUN docker-php-ext-install \
    bz2 gd intl mysqli pdo_mysql zip gettext mcrypt
#    curl bz2 fileinfo gd gettext intl mbstring \
#    pdo mysqli pdo_mysql sqlite3 xml dom simplexml \
#    zip mcrypt

# Switch PHP-FPM from TCP port to Unix socket
# zz-docker.conf loads after www.conf (z > w) and overrides listen
RUN sed -i 's|^listen = .*|listen = /run/php/php5.6-fpm.sock|' /usr/local/etc/php-fpm.d/zz-docker.conf
# && sed -i 's|;listen.owner = www-data|listen.owner = www-data|' /usr/local/etc/php-fpm.d/www.conf \
# && sed -i 's|;listen.group = www-data|listen.group = www-data|' /usr/local/etc/php-fpm.d/www.conf \
# && sed -i 's|;listen.mode = 0660|listen.mode = 0660|' /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /run/php && chmod 777 /run/php

CMD ["php-fpm", "-F"]
