ARG BUILD_PHP_IMAGE

FROM ${BUILD_PHP_IMAGE}

USER root

ARG DRUSH_LAUNCHER_VERSION
ARG BUILD_DEV='false'

RUN set -ex; \
    # Dependencies
    apk add --no-cache --virtual .build freetype-dev libpng-dev libjpeg-turbo-dev; \
    apk add --no-cache freetype libpng libjpeg-turbo libxml2-dev; \
    # Dev dependencies
    if [ "${BUILD_DEV}" = 'true' ]; then \
        apk add --no-cache mariadb-client rsync; \
    fi; \
    # Install BCMath, GD and SOAP
    if [ "${PHP_VERSION: :3}" = '7.4' ]; then \
        docker-php-ext-configure gd \
            --with-freetype \
            --with-jpeg; \
    else \
        docker-php-ext-configure gd \
            --with-gd \
            --with-freetype-dir=/usr/include/ \
            --with-png-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/; \
    fi; \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1); \
    docker-php-ext-install -j${NPROC} bcmath gd soap; \
    # Install Drush launcher
    wget -O /tmp/drush.phar https://github.com/drush-ops/drush-launcher/releases/download/${DRUSH_LAUNCHER_VERSION}/drush.phar; \
    chmod +x /tmp/drush.phar; \
    mv /tmp/drush.phar /usr/local/bin/drush; \
    # Remove build dependencies
    apk del .build

USER 1001
