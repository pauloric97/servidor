# Usar uma imagem base com PHP 8.1
FROM php:8.1-apache

# Instalar as extensões do PHP necessárias
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions pdo_mysql mysqli gd zip mbstring iconv imap bcmath ctype fileinfo json mbstring openssl pdo tokenizer xml curl

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Instalar ferramentas adicionais
RUN apt-get update && apt-get install -y \
        curl \
        git \
        zip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar a aplicação para o container
COPY . /var/www/html

# Conceder permissões apropriadas
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

# Definir diretivas do PHP para o upload de arquivos
RUN { \
        echo 'upload_max_filesize=50M'; \
        echo 'max_file_uploads=50'; \
        echo 'post_max_size=100M'; \
    } > /usr/local/etc/php/conf.d/uploads.ini

# Limpar cache do APT e arquivos desnecessários
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# O resto da configuração e os passos para instalar o sistema serão gerenciados
# pelo script de instalação do Laravel ou manualmente após a criação do container.
