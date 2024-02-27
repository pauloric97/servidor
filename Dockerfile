# Usar uma imagem base com PHP 8.0
FROM php:8.0-apache

# Definir argumentos para versões específicas, se necessário
# ARG PHP_EXT_INSTALLER_VERSION=latest

# Instalar as extensões do PHP necessárias
# Usando o script de instalação de extensões PHP para simplificar o processo
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions pdo_mysql mysqli gd zip mbstring iconv imap

# Ajustar fontes do Debian se estivermos usando a versão 9 (Stretch)
RUN if [ "$(grep '^VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')" = "9" ]; then \
        sed -i -e 's/deb.debian.org/archive.debian.org/g' \
               -e 's/security.debian.org/archive.debian.org/g' \
               -e '/stretch-updates/d' /etc/apt/sources.list; \
    fi

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Habilitar allow_url_fopen no PHP
RUN echo 'allow_url_fopen=On' > /usr/local/etc/php/conf.d/allow_url_fopen.ini

# Copiar a aplicação para o container
COPY . /var/www/html

# Conceder permissões apropriadas
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Instalar ferramentas adicionais, se necessário
RUN apt-get update && apt-get install -y \
        curl \
        git \
        zip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar o Composer se necessário
# ...

# Limpar cache do APT e arquivos desnecessários
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Definir diretivas adicionais do PHP, se necessário
# ...
