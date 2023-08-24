FROM nginx:alpine

# copy source code
COPY . /var/www

# copy nginx configuration
COPY docker/nginx/tekno.conf /etc/nginx/conf.d/tekno.conf

# # copy ssl certificate
# COPY docker/nginx/ssl/etc/letsencrypt /etc/letsencrypt

# expose port
EXPOSE 80
# EXPOSE 443


