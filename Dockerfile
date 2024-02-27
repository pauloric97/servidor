# Usar uma imagem base com PHP 8.0
FROM php:8.0-apache

# Instalar as extensões do PHP necessárias
RUN docker-php-ext-install pdo_mysql mysqli
RUN apt-get update && apt-get install -y \
        libzip-dev \
        libpng-dev \
        libonig-dev \
        libcurl4-openssl-dev \
        libssl-dev \
        libc-client-dev \
        libkrb5-dev \
        libgd-dev \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-install -j$(nproc) imap

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Habilitar allow_url_fopen no PHP
RUN echo 'allow_url_fopen=On' >> /usr/local/etc/php/conf.d/docker-php-ext-allow_url_fopen.ini

# Copiar a aplicação para o container
COPY . /var/www/html

# Conceder permissões apropriadas
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
