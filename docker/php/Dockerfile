ARG PHP_TAG=8.5-fpm-alpine
FROM php:${PHP_TAG}

RUN set -eux; \
  apk add --no-cache bash git unzip icu-libs libzip; \
  apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS icu-dev libzip-dev zlib-dev; \
  docker-php-ext-install -j"$(nproc)" intl zip; \
  apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /app
CMD ["php-fpm"]
