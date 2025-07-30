# ---------- etapa de build ----------
FROM composer:2 AS build
WORKDIR /app
COPY . /app

# instala dependências PHP ignorando requisitos de plataforma
RUN composer install \
      --no-interaction \
      --no-dev \
      --no-scripts \
      --optimize-autoloader \
      --ignore-platform-reqs

# ---------- etapa de runtime ----------
FROM php:8.2-apache

# extensões necessárias para PostgreSQL
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql

# copia o código gerado na etapa de build
RUN cp /app/config-sample.php /app/config.php
COPY --from=build /app /var/www/html

# permite URLs amigáveis
RUN a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]
