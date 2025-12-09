#!/usr/bin/env sh
set -eu

APP_DIR="${APP_DIR:-/app}"
SYMFONY_VERSION="${SYMFONY_VERSION:-8.0.x}"
SYMFONY_PACK="${SYMFONY_PACK:-api}"

export COMPOSER_HOME="${COMPOSER_HOME:-/tmp/composer}"
export COMPOSER_ALLOW_SUPERUSER="${COMPOSER_ALLOW_SUPERUSER:-1}"

echo "APP_DIR=${APP_DIR} SYMFONY_VERSION=${SYMFONY_VERSION} SYMFONY_PACK=${SYMFONY_PACK}"

if [ ! -f "${APP_DIR}/composer.json" ]; then
  echo "🧩 Installing Symfony into ${APP_DIR}…"

  TMP_DIR="$(mktemp -d)"
  composer create-project "symfony/skeleton:${SYMFONY_VERSION}" "${TMP_DIR}" --no-interaction

  case "${SYMFONY_PACK}" in
    api) ;;
    webapp) (cd "${TMP_DIR}" && composer require webapp --no-interaction) ;;
    api-platform) (cd "${TMP_DIR}" && composer require api-platform/api-pack --no-interaction) ;;
    *)
      echo "❌ Unknown SYMFONY_PACK='${SYMFONY_PACK}' (api|webapp|api-platform)"
      rm -rf "${TMP_DIR}"
      exit 1
      ;;
  esac

  cp -a "${TMP_DIR}/." "${APP_DIR}/"
  rm -rf "${TMP_DIR}"
fi

# Assure des permissions traversables/lecture (évite "Primary script unknown" si le host monte /app en 700)
chmod a+rx "${APP_DIR}" 2>/dev/null || true
find "${APP_DIR}" -type d -exec chmod a+rx {} + 2>/dev/null || true
find "${APP_DIR}" -type f -exec chmod a+r {} + 2>/dev/null || true

# Dossiers runtime Symfony
mkdir -p "${APP_DIR}/var/cache" "${APP_DIR}/var/log" || true
chown -R www-data:www-data "${APP_DIR}/var" 2>/dev/null || true

exec docker-php-entrypoint "$@"
