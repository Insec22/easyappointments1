# Build
FROM composer:2 AS build
WORKDIR /app
COPY . /app
RUN composer install --no-interaction --no-dev --no-scripts --optimize-autoloader

# Runtime
FROM php:8.2-apache
RUN apt-get update \
    && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql
COPY --from=build /app /var/www/html
