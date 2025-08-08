# Use nginx to serve the static HTML dashboard
FROM nginx:alpine

# Copy the dashboard HTML file to nginx's default directory
COPY index.html /usr/share/nginx/html/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
