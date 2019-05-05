FROM php:7.2.1-apache
MAINTAINER mschirbel
RUN docker-php-ext-install pdo pdo_mysql mysqli
COPY ./index.php /var/www/html/