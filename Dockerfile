# Stage 1: Build the PHP environment
FROM php:8.1-fpm as base

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git

# Install Composer
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www

# Copy the application code to the container
COPY . /var/www

# Install PHP dependencies via Composer
RUN composer install --no-dev --optimize-autoloader

# Expose the necessary port for PHP-FPM (default is 9000)
EXPOSE 9000

# Command to run PHP-FPM server
CMD ["php-fpm"]