#!/bin/sh
set -e

host=$(hostname -i || echo '127.0.0.1')
ping=$(SCRIPT_NAME=${PHP_FPM_PING_PATH} \
  SCRIPT_FILENAME=${PHP_FPM_PING_PATH} \
  REQUEST_METHOD=GET \
  cgi-fcgi -bind -connect "${host}:9000" 2>&1 | tail -1)

if [ ! -z "${ping}" ] && [ "${ping}" = 'PONG' ]; then
  exit 0
fi

exit 1
