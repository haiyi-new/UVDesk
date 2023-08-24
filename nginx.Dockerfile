FROM nginx:alpine

# remove default configuration
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80