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

# Replace this hack with NSS wrapper once accepted
# see https://bugs.alpinelinux.org/issues/6710
if ! id -u "$(id -u)" > /dev/null 2>&1; then
  echo "${USER_NAME}:x:$(id -u):$(id -g):${USER_NAME}:${USER_HOME}:/sbin/nologin" >> /etc/passwd;
fi

exec /usr/local/bin/docker-php-entrypoint "$@"
