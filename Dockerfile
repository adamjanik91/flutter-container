FROM ubuntu:22.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa ca-certificates \
    && apt-get clean

# Git tuning to prevent timeouts and clone failures
RUN git config --global http.postBuffer 524288000 \
    && git config --global http.lowSpeedLimit 0 \
    && git config --global http.lowSpeedTime 999999

# Environment variable for Flutter version
ENV FLUTTER_VERSION=3.22.0

# Clone Flutter SDK (use depth=1 if you want a faster/lighter clone)
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && cd /flutter && git checkout tags/${FLUTTER_VERSION}

# Add Flutter and Dart to PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Pre-download dependencies
# RUN flutter doctor

# Optional: Enable web support
RUN flutter config --enable-web

# Set default working directory for VS Code container
WORKDIR /workspace
