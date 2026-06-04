ARG BUILD_PHP_IMAGE

FROM ${BUILD_PHP_IMAGE}

USER root

ARG COMPOSER_VERSION

ENV LD_PRELOAD=libnss_wrapper.so \
    NSS_WRAPPER_GROUP=/tmp/group \
    NSS_WRAPPER_PASSWD=/tmp/passwd

RUN set -ex; \
    # Composer
    mkdir -p /.composer; \
    wget -qO- https://getcomposer.org/installer | php -- --version="${COMPOSER_VERSION}" --install-dir=/usr/local/bin --filename=composer; \
    # Git, OpenSSH client, patch and rsync
    apk add --no-cache git openssh-client patch rsync; \
    echo -e "Host *\n  StrictHostKeyChecking accept-new" > /etc/ssh/ssh_config; \
    # Xdebug
    apk add --no-cache linux-headers; \
    apk add --no-cache --virtual .build autoconf g++ make; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    apk del .build; \
    # NSS wrapper
    apk add --no-cache nss_wrapper; \
    touch \
      "${NSS_WRAPPER_GROUP}" \
      "${NSS_WRAPPER_PASSWD}"; \
    chmod u+rw,g+rw,o+rw \
      "${NSS_WRAPPER_GROUP}" \
      "${NSS_WRAPPER_PASSWD}"

ENV COMPOSER_CACHE_DIR=/tmp \
    COMPOSER_MEMORY_LIMIT=256M \
    PHP_ALLOW_URL_FOPEN=1 \
    PHP_DISABLE_FUNCTIONS='' \
    PHP_OPCACHE_JIT_BUFFER_SIZE=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_XDEBUG_CLIENT_DISCOVERY_HEADER='' \
    PHP_XDEBUG_CLIENT_HOST=localhost \
    PHP_XDEBUG_CLIENT_PORT=9003 \
    PHP_XDEBUG_DISCOVER_CLIENT_HOST=true \
    PHP_XDEBUG_FILE_LINK_FORMAT='' \
    PHP_XDEBUG_IDEKEY='' \
    PHP_XDEBUG_LOG_LEVEL=3 \
    PHP_XDEBUG_MAX_NESTING_LEVEL=256 \
    PHP_XDEBUG_MODE=off \
    PHP_XDEBUG_OUTPUT_DIR=/tmp \
    PHP_XDEBUG_START_WITH_REQUEST=default \
    PHP_XDEBUG_TRIGGER_VALUE='' \
    USER_HOME=/tmp \
    USER_GROUP=docker \
    USER_NAME=docker

USER 1001

COPY conf/xdebug.ini.tmpl ${PHP_INI_DIR}/conf.d/xdebug.ini.tmpl
COPY scripts/docker-entrypoint.sh /scripts/docker-entrypoint.sh
