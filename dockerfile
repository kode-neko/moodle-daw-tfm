FROM ubuntu:latest

# Envs to avoid interactive cli
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe

# Tools & PHP repo
RUN apt update
RUN apt upgrade -y
RUN apt install -y software-properties-common gnupg2
RUN apt install -y nano
RUN add-apt-repository ppa:ondrej/php
RUN apt update

# Moodle only support php 8.0 as max 
RUN apt install -y php8.0 php8.0-fpm php8.0-cli -y
RUN apt install -y graphviz aspell ghostscript clamav php8.0-pspell php8.0-curl php8.0-gd php8.0-intl php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-ldap php8.0-zip php8.0-soap php8.0-mbstring

# Install Nginx and copy config and moodle
RUN apt install -y nginx
COPY ./nginx.conf /etc/nginx/sites-available/default
COPY ./moodle /var/www/html/moodle
RUN mkdir /var/moodledata
RUN chown -R www-data /var/moodledata
RUN chmod -R 777 /var/moodledata
RUN chmod 0755 /var/www/html/moodle

# Some test files
COPY ./test.php /var/www/html
COPY ./init.sh /home

# Ports
EXPOSE 80