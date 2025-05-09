# .devcontainer/Dockerfile
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace


# Set environment variables
ENV PYTHONPATH=/workspace
ENV DJANGO_SETTINGS_MODULE=blawx.settings