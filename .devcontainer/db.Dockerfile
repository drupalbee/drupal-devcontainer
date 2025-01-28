# Use the default MariaDB image
FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=drupalroot
ENV MYSQL_DATABASE=drupal
ENV MYSQL_USER=drupal
ENV MYSQL_PASSWORD=drupal

# Expose the MySQL port to be accessible to the web container.
EXPOSE 3306
