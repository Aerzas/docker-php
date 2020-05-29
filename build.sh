#!/bin/sh
set -e;

build_version="${1}";
build_php_version="${2}";
if [ -z "${build_version}" ]; then
  echo 'Build version is required' >&2;
  exit 1;
fi;

registry_image='faering/php';
drush_launcher_version=0.6.0;
declare -A php_versions=(
  [7.2]=php:7.2.31-fpm-alpine3.11
  [7.3]=php:7.3.18-fpm-alpine3.11
  [7.4]=php:7.4.6-fpm-alpine3.11
);

build_base()
{
  php_image="${1}";
  php_version="${2}";

  docker build \
    --build-arg BUILD_PHP_IMAGE=${php_image} \
    --build-arg BUILD_PHP_VERSION=${php_version} \
    -t ${registry_image}:${php_version}-${build_version} \
    -f base/Dockerfile \
    ./base \
    --no-cache;
}

build_dev()
{
  php_version="${1}";

  docker build \
    --build-arg BUILD_PHP_IMAGE=${registry_image}:${php_version}-${build_version} \
    -t ${registry_image}:${php_version}-${build_version}-dev \
    -f dev/Dockerfile \
    ./dev \
    --no-cache;
}

build_drupal()
{
  php_version="${1}";

  docker build \
    --build-arg BUILD_PHP_IMAGE=${registry_image}:${php_version}-${build_version} \
    --build-arg DRUSH_LAUNCHER_VERSION=${drush_launcher_version} \
    -t ${registry_image}:${php_version}-${build_version}-drupal \
    -f drupal/Dockerfile \
    ./drupal \
    --no-cache;
}

build_drupal_dev()
{
  php_version="${1}";

  docker build \
    --build-arg BUILD_PHP_IMAGE=${registry_image}:${php_version}-${build_version}-dev \
    --build-arg DRUSH_LAUNCHER_VERSION=${drush_launcher_version} \
    --build-arg BUILD_DEV=true \
    -t ${registry_image}:${php_version}-${build_version}-drupal-dev \
    -f drupal/Dockerfile \
    ./drupal \
    --no-cache;
}

build_php()
{
  php_version="${1}";
  if [ -z "${php_version}" ]; then
    echo 'Build PHP version is required' >&2;
    return 1;
  fi;
  if [ -z "${php_versions[${php_version}]}" ]; then
    echo 'Build PHP version is invalid' >&2;
    return 1;
  fi;

  echo -e "\e[32mBuild PHP images ${php_version}\e[0m";

  # Build images
  build_base ${php_versions[${php_version}]} ${php_version};
  build_dev ${php_version};
  build_drupal ${php_version};
  build_drupal_dev ${php_version};

  # Push images
  docker push ${registry_image}:${php_version}-${build_version};
  docker push ${registry_image}:${php_version}-${build_version}-dev;
  docker push ${registry_image}:${php_version}-${build_version}-drupal;
  docker push ${registry_image}:${php_version}-${build_version}-drupal-dev;

  # Remove local images
  docker image rm \
    ${registry_image}:${php_version}-${build_version} \
    ${registry_image}:${php_version}-${build_version}-dev \
    ${registry_image}:${php_version}-${build_version}-drupal \
    ${registry_image}:${php_version}-${build_version}-drupal-dev;
}

# Build single PHP version
if [ ! -z "${build_php_version}" ]; then
  build_php ${build_php_version};
# Build all PHP versions
else
  for php_version in "${!php_versions[@]}"; do
    build_php ${php_version};
  done;
fi;
