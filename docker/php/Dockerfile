ARG PHP_TAG=8.5-fpm-alpine
FROM php:${PHP_TAG}

RUN set -eux; \
  apk add --no-cache bash git unzip icu-libs libzip rsync; \
  apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS icu-dev libzip-dev zlib-dev; \
  docker-php-ext-install -j"$(nproc)" intl zip; \
  apk del .build-deps

# Force php-fpm to listen on TCP for other containers (Caddy)
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /usr/local/etc/php-fpm.d/www.conf

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

COPY docker/php/entrypoint.sh /usr/local/bin/app-entrypoint
RUN sed -i 's/\r$//' /usr/local/bin/app-entrypoint \
 && chmod +x /usr/local/bin/app-entrypoint \
 && /bin/sh -n /usr/local/bin/app-entrypoint


WORKDIR /app
ENTRYPOINT ["app-entrypoint"]
