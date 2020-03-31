#!/bin/sh
set -e;

# Replace environment variables in template files
envs=`printf '${%s} ' $(sh -c "env|cut -d'=' -f1")`;
for filename in $(find ${PHP_INI_DIR} ${PHP_FPM_CONF_DIR} -name '*.tmpl'); do
    envsubst "$envs" < "$filename" > ${filename: :-5};
    rm "$filename";
done

exec /usr/local/bin/docker-php-entrypoint "$@"
