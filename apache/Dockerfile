FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-fcgid \
    && rm -rf /var/lib/apt/lists/*

# Enable required Apache modules
RUN a2enmod proxy proxy_fcgi setenvif rewrite headers ssl proxy_http proxy_balancer lbmethod_byrequests cgid remoteip

# Make Apache run as UID (same as host user and PHP-FPM)
# This ensures Apache can read/write the shared socket files
#RUN usermod  -u $USER_ID www-data \
# && groupmod -g $USER_ID www-data

# Forward logs to Docker log collector
RUN ln -sf /proc/1/fd/1 /var/log/apache2/access.log \
 && ln -sf /proc/1/fd/2 /var/log/apache2/error.log

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
