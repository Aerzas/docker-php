# PHP

PHP-FPM docker container image that requires no specific user or root permission to function.

Docker Hub image: [https://hub.docker.com/r/aerzas/php](https://hub.docker.com/r/aerzas/php)

## Docker compose example

```yaml
version: '3.5'
services:
    php:
        image: aerzas/php:8.1-latest
        environment:
            PHP_MEMORY_LIMIT: 256M
        ports:
            - '9000:9000'
        healthcheck:
            test: ["CMD", "/scripts/docker-healthcheck.sh"]
            interval: 30s
            timeout: 1s
            retries: 3
            start_period: 5s
```

Additional PHP configuration files can be mounted in `/usr/local/etc/php/conf.d/`, files mounted as `.tmpl` will have
their environment variables automatically replaced.

## Environment Variables

| Variable                              | Default value (base)                                                         | Default value (dev)                   |
|---------------------------------------|------------------------------------------------------------------------------|---------------------------------------|
| **PHP**                               |                                                                              |                                       |
| `PHP_ALLOW_URL_FOPEN`                 | `0`                                                                          | `1`                                   |
| `PHP_DEFAULT_SOCKET_TIMEOUT`          | `60`                                                                         | `60`                                  |
| `PHP_DISABLE_FUNCTIONS`               | `exec,passthru,shell_exec,system,proc_open,popen,parse_ini_file,show_source` |                                       |
| `PHP_DISPLAY_ERRORS`                  | `0`                                                                          | `0`                                   |
| `PHP_DISPLAY_STARTUP_ERRORS`          | `0`                                                                          | `0`                                   |
| `PHP_ERROR_REPORTING`                 | `'E_ALL & ~E_DEPRECATED & ~E_STRICT'`                                        | `'E_ALL & ~E_DEPRECATED & ~E_STRICT'` |
| `PHP_EXPOSE`                          | `0`                                                                          | `0`                                   |
| `PHP_FPM_ACCESS_LOG`                  | `/dev/null`                                                                  | `/dev/null`                           |
| `PHP_LOG_ERRORS`                      | `1`                                                                          | `1`                                   |
| `PHP_LOG_ERRORS_MAX_LEN`              | `1024`                                                                       | `1024`                                |
| `PHP_MAX_EXECUTION_TIME`              | `30`                                                                         | `30`                                  |
| `PHP_MAX_FILE_UPLOADS`                | `20`                                                                         | `20`                                  |
| `PHP_MAX_INPUT_TIME`                  | `60`                                                                         | `60`                                  |
| `PHP_MAX_INPUT_VARS`                  | `2500`                                                                       | `2500`                                |
| `PHP_MEMORY_LIMIT`                    | `128M`                                                                       | `128M`                                |
| `PHP_OUTPUT_BUFFERING`                | `4096`                                                                       | `4096`                                |
| `PHP_POST_MAX_SIZE`                   | `8M`                                                                         | `8M`                                  |
| `PHP_REALPATH_CACHE_SIZE`             | `4096k`                                                                      | `4096k`                               |
| `PHP_REALPATH_CACHE_TTL`              | `120`                                                                        | `120`                                 |
| `PHP_UPLOAD_MAX_FILESIZE`             | `8M`                                                                         | `8M`                                  |
| **Assertions**                        |                                                                              |                                       |
| `PHP_ZEND_ASSERTIONS`                 | `0`                                                                          | `0`                                   |
| `PHP_ASSERT_ACTIVE`                   | `0`                                                                          | `0`                                   |
| **Date**                              |                                                                              |                                       |
| `PHP_DATE_TIMEZONE`                   | `UTC`                                                                        | `UTC`                                 |
| **Mail**                              |                                                                              |                                       |
| `PHP_SENDMAIL_PATH`                   | `/bin/true`                                                                  | `/bin/true`                           |
| **OPcache**                           |                                                                              |                                       |
| `PHP_OPCACHE_ENABLE`                  | `1`                                                                          | `1`                                   |
| `PHP_OPCACHE_INTERNED_STRINGS_BUFFER` | `16`                                                                         | `16`                                  |
| `PHP_OPCACHE_MAX_ACCELERATED_FILES`   | `20000`                                                                      | `20000`                               |
| `PHP_OPCACHE_MAX_WASTED_PERCENTAGE`   | `10`                                                                         | `10`                                  |
| `PHP_OPCACHE_MEMORY_CONSUMPTION`      | `256`                                                                        | `256`                                 |
| `PHP_OPCACHE_REVALIDATE_FREQ`         | `0`                                                                          | `0`                                   |
| `PHP_OPCACHE_VALIDATE_TIMESTAMPS`     | `0`                                                                          | `1`                                   |
| `PHP_OPCACHE_JIT`                     | `tracing`                                                                    | `tracing`                             |
| `PHP_OPCACHE_JIT_BUFFER_SIZE`         | `32M`                                                                        | `0`                                   |
| **OpenSSL**                           |                                                                              |                                       |
| `PHP_OPENSSL_CAFILE`                  |                                                                              |                                       |
| `PHP_OPENSSL_CAPATH`                  |                                                                              |                                       |
| **Session**                           |                                                                              |                                       |
| `PHP_SESSION_SAVE_HANDLER`            | `files`                                                                      | `files`                               |
| `PHP_SESSION_SAVE_PATH`               | `/tmp`                                                                       | `/tmp`                                |
| `PHP_SESSION_COOKIE_SECURE`           | `1`                                                                          | `1`                                   |
| `PHP_SESSION_NAME`                    | `PHPSESSID`                                                                  | `PHPSESSID`                           |
| `PHP_SESSION_AUTO_START`              | `0`                                                                          | `0`                                   |
| `PHP_SESSION_COOKIE_PATH`             | `/`                                                                          | `/`                                   |
| `PHP_SESSION_COOKIE_DOMAIN`           |                                                                              |                                       |
| `PHP_SESSION_SERIALIZE_HANDLER`       | `php`                                                                        | `php`                                 |
| `PHP_SESSION_GC_PROBABILITY`          | `1`                                                                          | `1`                                   |
| `PHP_SESSION_GC_DIVISOR`              | `100`                                                                        | `100`                                 |
| `PHP_SESSION_GC_MAXLIFETIME`          | `1440`                                                                       | `1440`                                |
| `PHP_SESSION_REFERER_CHECK`           |                                                                              |                                       |
| `PHP_SESSION_CACHE_EXPIRE`            | `180`                                                                        | `180`                                 |
| **FPM Ping**                          |                                                                              |                                       |
| `PHP_FPM_PING_PATH`                   | `/ping`                                                                      | `/ping`                               |
| `PHP_FPM_PING_RESPONSE`               | `PONG`                                                                       | `PONG`                                |
| **FPM Process Manager**               |                                                                              |                                       |
| `PHP_FPM_PM_STATUS_PATH`              |                                                                              |                                       |
| **Composer (dev only)**               |                                                                              |                                       |
| `COMPOSER_CACHE_DIR`                  |                                                                              | `/tmp`                                |
| `COMPOSER_MEMORY_LIMIT`               |                                                                              | `256M`                                |
| **Xdebug (dev only)**                 |                                                                              |                                       |
| `PHP_XDEBUG_CLIENT_DISCOVERY_HEADER`  |                                                                              |                                       |
| `PHP_XDEBUG_CLIENT_HOST`              |                                                                              | `localhost`                           |
| `PHP_XDEBUG_CLIENT_PORT`              |                                                                              | `9000`                                |
| `PHP_XDEBUG_DISCOVER_CLIENT_HOST`     |                                                                              | `true`                                |
| `PHP_XDEBUG_FILE_LINK_FORMAT`         |                                                                              |                                       |
| `PHP_XDEBUG_IDEKEY`                   |                                                                              |                                       |
| `PHP_XDEBUG_LOG_LEVEL`                |                                                                              | `3`                                   |
| `PHP_XDEBUG_MAX_NESTING_LEVEL`        |                                                                              | `256`                                 |
| `PHP_XDEBUG_MODE`                     |                                                                              | `off`                                 |
| `PHP_XDEBUG_OUTPUT_DIR`               |                                                                              | `/tmp`                                |
| `PHP_XDEBUG_START_WITH_REQUEST`       |                                                                              | `default`                             |
| `PHP_XDEBUG_TRIGGER_VALUE`            |                                                                              |                                       |
| **User (dev only)**                   |                                                                              |                                       |
| `USER_HOME`                           |                                                                              | `/tmp`                                |
| `USER_NAME`                           |                                                                              | `docker`                              |
