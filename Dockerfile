FROM ghcr.io/cirruslabs/flutter:3.27.1

WORKDIR /app

# Copy dependency files first for better caching
COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Generate code (build_runner needs .env)
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Enable web support
RUN flutter config --enable-web

EXPOSE 8080

# Run Flutter web dev server
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
