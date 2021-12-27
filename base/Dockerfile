ARG BUILD_PHP_IMAGE

FROM ${BUILD_PHP_IMAGE}

ENV APP_ROOT="/var/www/html" \
    HOME="/etc/home" \
    PHP_FPM_CONF_DIR="/usr/local/etc/php-fpm.d"

RUN set -ex; \
    # Install OPcache
    docker-php-ext-configure opcache --enable-opcache; \
    docker-php-ext-install opcache; \
    # Instal PHPRedis
    apk add --no-cache --virtual .build autoconf g++ make; \
    pecl install redis; \
    docker-php-ext-enable redis; \
    apk del .build; \
    # Install PDO MySQL
    docker-php-ext-install pdo_mysql; \
    docker-php-ext-enable pdo_mysql; \
    # Install envsubst
    apk add --update libintl; \
    apk add --no-cache --virtual .gettext gettext; \
    cp /usr/bin/envsubst /usr/local/bin/envsubst; \
    apk del .gettext; \
    # Install FCGI for healthcheck
    apk add --no-cache fcgi; \
    # Prepare base folders
    mkdir -p ${PHP_INI_DIR}/conf.d \
      ${PHP_INI_DIR}/includes \
      ${PHP_FPM_CONF_DIR} \
      ${HOME}; \
    # Execute php as any user
    chmod -R 777 ${PHP_INI_DIR} \
       ${PHP_FPM_CONF_DIR} \
       ${HOME}; \
    chgrp -R 0 ${PHP_INI_DIR} \
       ${PHP_FPM_CONF_DIR} \
       ${HOME}

ENV PHP_ALLOW_URL_FOPEN=0 \
    PHP_DEFAULT_SOCKET_TIMEOUT=60 \
    PHP_DISABLE_FUNCTIONS=exec,passthru,shell_exec,system,proc_open,popen,parse_ini_file,show_source \
    PHP_DISPLAY_ERRORS=0 \
    PHP_DISPLAY_STARTUP_ERRORS=0 \
    PHP_ERROR_REPORTING='E_ALL & ~E_DEPRECATED & ~E_STRICT' \
    PHP_EXPOSE=0 \
    PHP_FPM_ACCESS_LOG=/dev/null \
    PHP_FPM_PING_PATH=/ping \
    PHP_FPM_PING_RESPONSE='PONG' \
    PHP_FPM_PM_STATUS_PATH='' \
    PHP_LOG_ERRORS=1 \
    PHP_LOG_ERRORS_MAX_LEN=1024 \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_MAX_INPUT_TIME=60 \
    PHP_MAX_INPUT_VARS=2500 \
    PHP_MEMORY_LIMIT=128M \
    PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=16 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=20000 \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE=10 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=256 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_JIT=tracing \
    PHP_OPCACHE_JIT_BUFFER_SIZE=32M \
    PHP_OUTPUT_BUFFERING=4096 \
    PHP_POST_MAX_SIZE=8M \
    PHP_REALPATH_CACHE_SIZE=4096k \
    PHP_REALPATH_CACHE_TTL=120 \
    PHP_UPLOAD_MAX_FILESIZE=8M \
    PHP_DATE_TIMEZONE=UTC \
    PHP_SENDMAIL_PATH=/bin/true \
    PHP_SESSION_SAVE_HANDLER=files \
    PHP_SESSION_SAVE_PATH=/tmp \
    PHP_SESSION_COOKIE_SECURE=1 \
    PHP_SESSION_NAME=PHPSESSID \
    PHP_SESSION_AUTO_START=0 \
    PHP_SESSION_COOKIE_PATH=/ \
    PHP_SESSION_COOKIE_DOMAIN=''\
    PHP_SESSION_SERIALIZE_HANDLER=php \
    PHP_SESSION_GC_PROBABILITY=1 \
    PHP_SESSION_GC_DIVISOR=100 \
    PHP_SESSION_GC_MAXLIFETIME=1440 \
    PHP_SESSION_REFERER_CHECK='' \
    PHP_SESSION_CACHE_EXPIRE=180 \
    PHP_ZEND_ASSERTIONS=0 \
    PHP_ASSERT_ACTIVE=0 \
    PHP_OPENSSL_CAFILE='' \
    PHP_OPENSSL_CAPATH=''

USER 1001

ARG BUILD_PHP_VERSION

COPY conf/php.ini.tmpl ${PHP_INI_DIR}/php.ini.tmpl
COPY conf/conf.d/${BUILD_PHP_VERSION}/*.tmpl ${PHP_INI_DIR}/conf.d/
COPY conf/php-fpm.d/*.tmpl ${PHP_FPM_CONF_DIR}/
COPY scripts/*.sh /scripts/

WORKDIR $APP_ROOT
EXPOSE 9000

STOPSIGNAL SIGTERM

ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["php-fpm"]
