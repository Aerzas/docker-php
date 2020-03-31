ARG BUILD_PHP_IMAGE

FROM ${BUILD_PHP_IMAGE}

USER root

RUN set -ex; \
    # Composer
    mkdir -p /.composer; \
    wget -qO- https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
    # Git and OpenSSH client
    apk add --no-cache git openssh-client; \
    echo -e "Host *\n  StrictHostKeyChecking accept-new" > /etc/ssh/ssh_config; \
    # Xdebug
    apk add --no-cache --virtual .build autoconf g++ make; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    apk del .build; \
    mkdir -p /tmp/xdebug/profiler; \
    mkdir -p /tmp/xdebug/trace; \
    # Replace this hack whith NSS wrapper once accepted
    # see https://bugs.alpinelinux.org/issues/6710
    chgrp 0 /etc/passwd; \
    chmod g+rwX /etc/passwd

ENV COMPOSER_CACHE_DIR=/tmp \
    COMPOSER_MEMORY_LIMIT=256M \
    PHP_ALLOW_URL_FOPEN=1 \
    PHP_DISABLE_FUNCTIONS='' \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_XDEBUG_ENABLE=1 \
    PHP_XDEBUG_COVERAGE_ENABLE=0 \
    PHP_XDEBUG_FILE_LINK_FORMAT='"phpstorm://open?file=%f&line=%l"' \
    PHP_XDEBUG_IDEKEY='PHPSTORM' \
    PHP_XDEBUG_MAX_NESTING_LEVEL=256 \
    PHP_XDEBUG_PROFILER_ENABLE=0 \
    PHP_XDEBUG_PROFILER_ENABLE_TRIGGER=1 \
    PHP_XDEBUG_REMOTE_ENABLE=1 \
    PHP_XDEBUG_REMOTE_CONNECT_BACK=1 \
    PHP_XDEBUG_REMOTE_HOST=localhost \
    PHP_XDEBUG_REMOTE_PORT=9000 \
    PHP_XDEBUG_TRACE_ENABLE=0 \
    PHP_XDEBUG_TRACE_ENABLE_TRIGGER=1 \
    USER_HOME=/tmp \
    USER_NAME=docker

USER 1001

COPY conf/xdebug.ini.tmpl ${PHP_INI_DIR}/conf.d/xdebug.ini.tmpl
COPY scripts/docker-entrypoint.sh /scripts/docker-entrypoint.sh
