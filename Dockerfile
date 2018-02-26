FROM php:7.2-fpm-stretch

RUN set -ex \
 && savedAptMark="$(apt-mark showmanual)" \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      libjpeg-dev \
      libpng-dev \
 && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
 && docker-php-ext-install \
      gd \
      mysqli \
      pdo_mysql \
      pcntl \
      opcache \
 && pecl install apcu-5.1.10 \
 && docker-php-ext-enable apcu \
 ## Reset apt-mark's manual list so build dependencies will be removed.
 && apt-mark auto '.*' > /dev/null \
 && apt-mark manual $savedAptMark \
 && ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
    | awk '/=>/ { print $3 }' \
    | sort -u \
    | xargs -r dpkg-query -S \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual \
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
 && rm -rf /var/lib/apt/lists/*

COPY conf/php.ini /usr/local/etc/php/conf.d/php.ini
