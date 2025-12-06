ARG PHP_TAG=8.5-fpm-alpine
FROM php:${PHP_TAG}

RUN set -eux; \
  apk add --no-cache bash git unzip icu-libs libzip rsync; \
  apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS icu-dev libzip-dev zlib-dev; \
  docker-php-ext-install -j"$(nproc)" intl zip; \
  apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY docker/php/entrypoint.sh /usr/local/bin/app-entrypoint
RUN chmod +x /usr/local/bin/app-entrypoint

WORKDIR /app
ENTRYPOINT ["app-entrypoint"]
CMD ["php-fpm"]
