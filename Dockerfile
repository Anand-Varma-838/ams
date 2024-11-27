# Use official PHP image with FPM (FastCGI Process Manager)
FROM php:8.1-fpm

# Install necessary PHP extensions and system dependencies
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
    php-mbstring \
    php-bcmath \
    php-pdo-mysql \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory to /var/www
WORKDIR /var/www

# Copy the application files into the container
COPY . .

# Commenting out the composer install command for now to prevent errors during image build
# RUN composer install -vvv

# Set proper file permissions for Laravel (storage and cache directories)
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache && \
    chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache && \
    chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
