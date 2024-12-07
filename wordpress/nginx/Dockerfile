FROM nginx:1.27.3-alpine

# Install gettext for envsubst
RUN apk add --no-cache gettext openssl

# Create directories
RUN mkdir -p /etc/nginx/ssl

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Copy default Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]