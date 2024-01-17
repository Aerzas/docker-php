ARG BUILD_PHP_IMAGE

FROM ${BUILD_PHP_IMAGE}

USER root

ARG BUILD_DEV='false'

RUN set -ex; \
    # Dependencies
    apk add --no-cache --virtual .build freetype-dev libpng-dev libjpeg-turbo-dev; \
    apk add --no-cache freetype libpng libjpeg-turbo libwebp-dev libxml2-dev libzip-dev zip; \
    # Dev dependencies
    if [ "${BUILD_DEV}" = 'true' ]; then \
        apk add --no-cache mariadb-client rsync; \
    fi; \
    # Install BCMath, GD, SOAP, and ZIP
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp; \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1); \
    docker-php-ext-install -j${NPROC} bcmath gd soap zip; \
    # Remove build dependencies
    apk del .build

USER 1001
