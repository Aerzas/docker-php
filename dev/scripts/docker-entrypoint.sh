#!/bin/sh
set -e;

# Xdebug log path
if [ -n "${PHP_XDEBUG_REMOTE_LOG}" ]; then
  export PHP_XDEBUG_REMOTE_LOG_PATH='Protocols h2c http/1.1'
else
  export PHP_XDEBUG_REMOTE_LOG_PATH="${PHP_XDEBUG_LOG_DIR}/xdebug.log"
fi

# Replace environment variables in template files
envs=`printf '${%s} ' $(sh -c "env|cut -d'=' -f1")`;
for filename in $(find ${PHP_INI_DIR} ${PHP_FPM_CONF_DIR} -name '*.tmpl'); do
    envsubst "$envs" < "$filename" > ${filename: :-5};
    rm "$filename";
done

# Replace this hack whith NSS wrapper once accepted
# see https://bugs.alpinelinux.org/issues/6710
if ! id -u $(id -u) > /dev/null 2>&1; then
  echo "${USER_NAME}:x:$(id -u):$(id -g):${USER_NAME}:${USER_HOME}:/sbin/nologin" >> /etc/passwd;
fi

exec /usr/local/bin/docker-php-entrypoint "$@"
