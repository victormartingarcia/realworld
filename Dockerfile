FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV UV_CACHE_DIR=/opt/uv-cache
ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT=/opt/venv

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Create cache directory for uv (before dependency installation)
RUN mkdir -p /opt/uv-cache

# Set work directory
WORKDIR /app

# Copy uv files first (for better Docker layer caching)
COPY pyproject.toml uv.lock* ./

# Install dependencies with caching enabled
RUN uv sync --frozen

# Copy project files (this layer will only rebuild when source code changes)
COPY . .

# Expose port
EXPOSE 8000

# Run migrations and start server
CMD ["uv", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
