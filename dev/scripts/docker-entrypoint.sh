#!/bin/sh
set -e;

# Replace environment variables in template files
envs=$(printf '${%s} ' $(sh -c "env | cut -d'=' -f1"))
find "${PHP_INI_DIR}" "${PHP_FPM_CONF_DIR}" -type f -name '*.tmpl' > /tmp/tmpl
while IFS= read -r filename; do
  envsubst "${envs}" <"${filename}" >"${filename%.tmpl}"
  rm "${filename}"
done < /tmp/tmpl
rm /tmp/tmpl

# Mock group and passwd files
echo "${USER_GROUP}:x:$(id -g)" >> "${NSS_WRAPPER_GROUP}";
echo "${USER_NAME}:x:$(id -u):$(id -g):${USER_NAME}:${USER_HOME}:/sbin/nologin" >> "${NSS_WRAPPER_PASSWD}";

exec /usr/local/bin/docker-php-entrypoint "$@"
