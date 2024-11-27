# Use an official PHP runtime as a parent image
FROM php:8.1-fpm as base

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim unzip git curl

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql gd

# Install Composer
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]

# Copy the PHP app from the base stage
COPY --from=base /var/www /var/www

# Set working directory
WORKDIR /var/www

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
