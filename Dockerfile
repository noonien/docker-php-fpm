FROM php:5.6-fpm-alpine
MAINTAINER George Jiglau <george@mux.ro>

RUN apk upgrade --update \
    # install build dependencies
    && apk --update add --virtual .build-deps $PHPIZE_DEPS \
        freetype-dev imagemagick-dev libjpeg-turbo-dev libmcrypt-dev \
        libmemcached-dev libpng-dev libtool \

    && docker-php-source extract \

    # install pecl extensions
    && pecl install imagick redis-2.2.8 \
    && echo "no --disable-memcached-sasl" | pecl install memcached \
    && docker-php-ext-enable imagick memcached redis \

    # install php extensions
    && docker-php-ext-install curl dom hash iconv intl json mcrypt mysql \
        mysqli opcache pdo pdo_mysql simplexml snmp soap xml zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \

    # clean
    && apk del .build-deps \
    && docker-php-source delete \
    && rm -rf /var/cache/apk/*
