FROM nginx:alpine

# Clean old default files (optional but good practice)
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files
COPY . /usr/share/nginx/html

# Expose port 80 for web access
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]

