# Stage 1: Composer dependencies
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader
COPY . .

# Stage 2: PHP runtime
FROM php:8.3-alpine

# Install dependencies
RUN apk add --no-cache \
    git curl zip unzip libzip-dev libpng-dev oniguruma-dev libxml2-dev mariadb-client \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath pcntl zip

# Set working directory
WORKDIR /var/www/html

# Copy source code and vendor from builder
COPY . .
COPY --from=vendor /app/vendor ./vendor

# Set permissions for Laravel writable directories
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port for Laravel's built-in server
EXPOSE 8000

# Use environment variable PORT (Railway provides it automatically)
ENV PORT=8000

# Default command
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT}
