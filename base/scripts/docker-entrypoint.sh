#!/bin/sh
set -e

# Replace environment variables in template files
envs=$(printf '${%s} ' "$(sh -c \"env | cut -d'=' -f1\")")
find "${PHP_INI_DIR}" "${PHP_FPM_CONF_DIR}" -name '*.tmpl' \
  -exec sh -c 'filename="$1"; envsubst "${envs}" <"${filename}" >"${filename%?????}"' \
  -exec rm {} \;

exec /usr/local/bin/docker-php-entrypoint "$@"
