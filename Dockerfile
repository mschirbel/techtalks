FROM httpd:latest
MAINTAINER mschirbel
EXPOSE 80
COPY ./index.html /usr/local/apache2/htdocs/