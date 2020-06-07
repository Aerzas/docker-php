#!/bin/sh
set -e

# Replace environment variables in template files
envs=$(printf '${%s} ' $(sh -c "env | cut -d'=' -f1"))
find "${PHP_INI_DIR}" "${PHP_FPM_CONF_DIR}" -type f -name '*.tmpl' > /tmp/tmpl
while IFS= read -r filename; do
  envsubst "${envs}" <"${filename}" >"${filename%.tmpl}"
  rm "${filename}"
done < /tmp/tmpl
rm /tmp/tmpl

exec /usr/local/bin/docker-php-entrypoint "$@"
