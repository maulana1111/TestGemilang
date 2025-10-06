# Stage 1: Composer dependencies
FROM composer:2 AS vendor
WORKDIR /app

# Copy all project files (so artisan is available)
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Stage 2: PHP runtime
FROM php:8.3-alpine

# Install system dependencies & PHP extensions
RUN apk add --no-cache \
    git curl zip unzip libzip-dev libpng-dev oniguruma-dev libxml2-dev mariadb-client \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath pcntl zip

# Set working directory
WORKDIR /var/www/html

# Copy project and vendor from builder
COPY . .
COPY --from=vendor /app/vendor ./vendor

# Set permissions for writable dirs
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port
EXPOSE 8000
ENV PORT=8000

# Cache configs (optional but good)
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Run migration then start server
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT}
