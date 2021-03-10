#!/bin/sh
set -e

build_version="${1}"
build_php_version="${2}"
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2
  exit 1
fi

registry_image='aerzas/php'
composer_version=2.0.11
drush_launcher_version=0.9.0

php_base_tag() {
  php_version="${1}"
  if [ -z "${php_version}" ]; then
    echo 'PHP version is required' >&2
    return 1
  fi

  case ${php_version} in
  7.3)
    echo php:7.3.27-fpm-alpine3.13
    ;;
  7.4)
    echo php:7.4.16-fpm-alpine3.13
    ;;
  *)
    return 0
    ;;
  esac
}

build_base() {
  php_image="${1}"
  php_version="${2}"

  docker build \
    --build-arg BUILD_PHP_IMAGE="${php_image}" \
    --build-arg BUILD_PHP_VERSION="${php_version}" \
    -t "${registry_image}:${php_version}-${build_version}" \
    -f base/Dockerfile \
    ./base \
    --no-cache
}

build_dev() {
  php_version="${1}"

  docker build \
    --build-arg BUILD_PHP_IMAGE="${registry_image}:${php_version}-${build_version}" \
    --build-arg COMPOSER_VERSION="${composer_version}" \
    -t "${registry_image}:${php_version}-${build_version}-dev" \
    -f dev/Dockerfile \
    ./dev \
    --no-cache
}

build_drupal() {
  php_version="${1}"

  docker build \
    --build-arg BUILD_PHP_IMAGE="${registry_image}:${php_version}-${build_version}" \
    --build-arg DRUSH_LAUNCHER_VERSION="${drush_launcher_version}" \
    -t "${registry_image}:${php_version}-${build_version}-drupal" \
    -f drupal/Dockerfile \
    ./drupal \
    --no-cache
}

build_drupal_dev() {
  php_version="${1}"

  docker build \
    --build-arg BUILD_PHP_IMAGE="${registry_image}:${php_version}-${build_version}-dev" \
    --build-arg DRUSH_LAUNCHER_VERSION="${drush_launcher_version}" \
    --build-arg BUILD_DEV=true \
    -t "${registry_image}:${php_version}-${build_version}-drupal-dev" \
    -f drupal/Dockerfile \
    ./drupal \
    --no-cache
}

build_php() {
  php_version="${1}"
  if [ -z "${php_version}" ]; then
    echo 'Build PHP version is required' >&2
    return 1
  fi
  if [ -z "$(php_base_tag ${php_version})" ]; then
    echo 'Build PHP version is invalid' >&2
    return 1
  fi

  echo "$(printf '\033[32m')Build PHP images ${php_version}$(printf '\033[m')"

  # Build images
  build_base "$(php_base_tag ${php_version})" "${php_version}"
  build_dev "${php_version}"
  build_drupal "${php_version}"
  build_drupal_dev "${php_version}"

  # Push images
  docker push "${registry_image}:${php_version}-${build_version}"
  docker push "${registry_image}:${php_version}-${build_version}-dev"
  docker push "${registry_image}:${php_version}-${build_version}-drupal"
  docker push "${registry_image}:${php_version}-${build_version}-drupal-dev"

  # Remove local images
  docker image rm \
    "${registry_image}:${php_version}-${build_version}" \
    "${registry_image}:${php_version}-${build_version}-dev" \
    "${registry_image}:${php_version}-${build_version}-drupal" \
    "${registry_image}:${php_version}-${build_version}-drupal-dev"
}

# Build single PHP version
if [ -n "${build_php_version}" ]; then
  build_php "${build_php_version}"
# Build all PHP versions
else
  build_php 7.3
  build_php 7.4
fi
