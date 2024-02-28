FROM composer:2.0 AS composer-build

FROM php:8.3.3-fpm-alpine

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} linux-headers \ 
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && apk del pcre-dev ${PHPIZE_DEPS}

ENV XDEBUG_MODE=coverage
COPY --from=composer /usr/bin/composer /usr/bin/composer