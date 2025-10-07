# Imagen base
FROM php:7.4-apache

# Instalar dependencias necesarias
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar el código de la aplicación al contenedor
COPY . /var/www/html/

# Exponer el puerto 80
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]
