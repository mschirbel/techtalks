FROM mysql:5.7.26
ENV MYSQL_DATABASE=marcelo
ENV MYSQL_RANDOM_ROOT_PASSWORD=true
ENV MYSQL_USER=tsbrdocker
ENV MYSQL_PASSWORD=docker
COPY ./setup.sql /tmp/
RUN ["mysql < /tmp/setup.sql"]