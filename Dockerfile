FROM ubuntu:22.04

# Install base dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa ca-certificates \
    openjdk-17-jdk wget \
    && apt-get clean

# Git tuning to prevent timeouts and clone failures
RUN git config --global http.postBuffer 524288000 \
    && git config --global http.lowSpeedLimit 0 \
    && git config --global http.lowSpeedTime 999999

# Environment variable for Flutter version
ENV FLUTTER_VERSION=3.22.0

# Clone Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && cd /flutter && git checkout tags/${FLUTTER_VERSION}

# Add Flutter and Dart to PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable Flutter web support
RUN flutter config --enable-web

# Android SDK installation
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=$ANDROID_SDK_ROOT

# Install command line tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -L --retry 5 --retry-delay 5 \
      -o /tmp/tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip /tmp/tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/tools.zip

# Set PATH after tools are installed
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Accept licenses and install required packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Pre-download Flutter dependencies
# RUN flutter doctor

# Set default working directory
WORKDIR /workspace
