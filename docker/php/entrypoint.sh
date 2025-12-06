#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/app}"
SYMFONY_VERSION="${SYMFONY_VERSION:-8.0.x}"
SYMFONY_PACK="${SYMFONY_PACK:-api}"

export COMPOSER_HOME="${COMPOSER_HOME:-/tmp/composer}"

if [ ! -f "${APP_DIR}/composer.json" ]; then
  echo "🧩 Bootstrapping Symfony into ${APP_DIR}…"

  tmp="$(mktemp -d)"
  composer create-project "symfony/skeleton:${SYMFONY_VERSION}" "${tmp}" --no-interaction

  if [ "${SYMFONY_PACK}" = "webapp" ]; then
    (cd "${tmp}" && composer require webapp --no-interaction)
  fi

  cp -a "${tmp}/." "${APP_DIR}/"
  rm -rf "${tmp}"

  mkdir -p "${APP_DIR}/var" "${APP_DIR}/var/cache" "${APP_DIR}/var/log" || true
  chown -R www-data:www-data "${APP_DIR}/var" 2>/dev/null || true

  echo "✅ Symfony ready."
fi

exec docker-php-entrypoint "$@"
