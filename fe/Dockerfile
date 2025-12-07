# Use the official Dart image as the base image
FROM dart:stable AS build

# Set the working directory
WORKDIR /app

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Copy pubspec.yaml and pubspec.lock files
COPY pubspec.yaml ./
COPY pubspec.lock ./

# Get Flutter dependencies
RUN flutter pub get

# Copy the rest of the application source code
COPY . .

# Build the Flutter web application
RUN flutter build web --release

# Use nginx to serve the static files
FROM nginx:alpine

# Copy the built web application to the nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
