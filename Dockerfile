# # Gunakan base image PHP-FPM
# FROM php:8.3-fpm

# # Install dependency sistem + library SQLite development
# RUN apt-get update && apt-get install -y \
#     git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
#     sqlite3 libsqlite3-dev pkg-config \
#     && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

# # Install Composer
# COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# # Set working directory
# WORKDIR /var/www/html

# # Copy semua file Laravel ke container
# COPY . .

# # Pastikan git tidak error karena ownership
# RUN git config --global --add safe.directory /var/www/html

# # Pastikan folder vendor bersih
# RUN rm -rf vendor

# # Install dependensi Laravel
# RUN composer install --no-dev --optimize-autoloader

# # Pastikan file database sqlite ada dan permission benar
# RUN mkdir -p /var/www/html/database && \
#     touch /var/www/html/database/database.sqlite && \
#     chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# # Jalankan migrate saat container start
# CMD php artisan migrate --force && php-fpm

FROM composer:2 AS vendor
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

FROM php:8.3-fpm-alpine
RUN apk add --no-cache nginx bash git curl zip unzip sqlite libpng-dev oniguruma-dev libxml2-dev libzip-dev sqlite-dev \
    && docker-php-ext-install pdo pdo_sqlite mbstring exif pcntl bcmath gd zip

WORKDIR /var/www/html
COPY . .
COPY --from=vendor /app/vendor ./vendor

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/nginx /var/www/html/database && touch database/database.sqlite \
    && chown -R www-data:www-data storage bootstrap/cache database

EXPOSE 8000

CMD php artisan migrate --force && \
    php-fpm & \
    nginx -g 'daemon off;'

