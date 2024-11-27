# Stage 1: Build the PHP environment
FROM php:8.1-fpm as base

# Install necessary dependencies for Laravel
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    php8.1-mbstring \
    php8.1-bcmath \
    php8.1-pdo-mysql

# Install Composer (using official Composer image)
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application code
COPY . /var/www

# Clear Composer cache
RUN composer clear-cache

# Try to install dependencies with composer
RUN composer install -vvv

# Set proper file permissions for Laravel (storage and cache directories)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose PHP-FPM port (default is 9000)
EXPOSE 9000

# Command to run PHP-FPM server
CMD ["php-fpm"]
