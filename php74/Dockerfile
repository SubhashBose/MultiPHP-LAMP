#FROM php:7.4-fpm-bullseye
# PHP 7.4 is EOL upstream. Aikido's patched drop-in for php:7.4-fpm-bullseye,
# with backported fixes for PHP2Shell (CVE-2026-109618/109619) and the
# 19 Nov 2026 release (phpAfterShell CVE-2026-126714, CVE-2026-115560, ...).
# `php -v` still reports 7.4.33 — the digest is what identifies the patched build.
# Pinned by digest (image built 2026-11-19). To update: re-resolve the tag's digest.
FROM public.ecr.aws/aikido-dev/php:7.4-fpm-bullseye@sha256:14970be9f5d11bb8e2dbcdcf17804872e0383160b53beba3dacef60758e374fe

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
