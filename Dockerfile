FROM php:fpm as base

ENV SITE_URL=$SITE_URL

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# php env
ENV PHP_MEMORY_LIMIT=1024M

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your PHP configuration file
COPY docker/php/php.ini /usr/local/etc/php/conf.d/custom-php.ini

# Configure and install GD extension
# RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# configure imap
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl

RUN docker-php-ext-install -j$(nproc) gd pdo_mysql mbstring exif pcntl bcmath zip imap mysqli

# Configure mailparser
RUN pecl install mailparse \
    && docker-php-ext-enable mailparse

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Install symfony CLI
# RUN composer global require symfony/cli

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user


# Set working directory
WORKDIR /var/www

EXPOSE 9000


FROM base as dev

USER $user

FROM base as prod

# copy source code
COPY . /var/www

# Copy existing application directory permissions
RUN chown -R $user:$user /var/www

# change user
USER $user

# run composer update
RUN composer update

