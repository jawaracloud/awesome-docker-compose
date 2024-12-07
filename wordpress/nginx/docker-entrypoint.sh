#!/bin/sh
set -e

# Print debug information
echo "Starting Nginx entrypoint..."

# Set default values if not provided
export SERVER_NAME=${SERVER_NAME:-localhost}
export CRT_PATH=${CRT_PATH:-/etc/nginx/ssl/default.crt}
export KEY_PATH=${KEY_PATH:-/etc/nginx/ssl/default.key}

# Ensure SSL directory exists
mkdir -p "$(dirname "$CRT_PATH")"
mkdir -p "$(dirname "$KEY_PATH")"

# Generate self-signed certificates if not provided
if [ ! -f "$CRT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
    echo "Generating self-signed SSL certificates..."
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout "$KEY_PATH" \
        -out "$CRT_PATH" \
        -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost"
fi

# Generate final Nginx configuration
echo "Generating Nginx configuration..."
envsubst '$SERVER_NAME $CRT_PATH $KEY_PATH' < /etc/nginx/templates/wordpress.conf.template > /etc/nginx/conf.d/default.conf

# Print out the generated configuration for debugging
echo "Generated Nginx configuration:"
cat /etc/nginx/conf.d/default.conf

# Execute CMD
echo "Starting Nginx..."
exec "$@"