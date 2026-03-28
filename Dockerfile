FROM ghcr.io/cirruslabs/flutter:3.27.1

# Run as non-root user
RUN useradd -m flutteruser
USER flutteruser

WORKDIR /home/flutteruser/app

# Enable web support
RUN flutter config --enable-web

# Copy dependency files first for better caching
COPY --chown=flutteruser pubspec.yaml pubspec.lock* ./
RUN flutter pub get

# Copy the rest of the project
COPY --chown=flutteruser . .

# Add web platform support and generate code
RUN flutter create --platforms=web . && \
    flutter pub get && \
    flutter pub run build_runner build --delete-conflicting-outputs

EXPOSE 8080

CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
