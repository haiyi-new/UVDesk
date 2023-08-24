FROM nginx:alpine as base

# remove default configuration
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80

FROM base as code

# copy source code
COPY . /var/www

FROM code as prod

# copy nginx configuration
COPY docker/nginx/ssl.conf /etc/nginx/conf.d/tekno.conf

# copy ssl certificate
COPY docker/nginx/ssl/etc/letsencrypt /etc/letsencrypt
COPY docker/nginx/tekno.conf /etc/nginx/conf.d/tekno.conf

EXPOSE 443

FROM code as profile

# copy nginx configuration
COPY docker/nginx/tekno.conf /etc/nginx/conf.d/tekno.conf