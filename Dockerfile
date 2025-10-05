FROM composer:2 AS vendor
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader

FROM php:8.3-alpine

RUN apk add --no-cache git curl zip unzip sqlite sqlite-dev libzip-dev oniguruma-dev libxml2-dev libpng-dev \
    && docker-php-ext-install pdo pdo_sqlite mbstring bcmath pcntl zip

WORKDIR /var/www/html
COPY . .
COPY --from=vendor /app/vendor ./vendor

RUN mkdir -p database && touch database/database.sqlite \
    && chown -R www-data:www-data storage bootstrap/cache database

EXPOSE 8000

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
