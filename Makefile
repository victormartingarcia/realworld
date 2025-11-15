# RealWorld Makefile
# Provides convenient commands for development workflow

# Colors for fancy output
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
WHITE := \033[37m
BOLD := \033[1m
RESET := \033[0m

# Project directories
PROJ_DIR := .

# Extract pre-commit option from command line arguments
ifneq (,$(filter all,$(MAKECMDGOALS)))
    precommit_option := $(filter all,$(MAKECMDGOALS))
endif

.PHONY: help init build up down open shell pre-commit test clean all

# Default target
.DEFAULT_GOAL := help

# Make 'all' do nothing when called as a target parameter
all:
	@:

help: ## Show this help message
	@echo "$(BOLD)$(CYAN)RealWorld Development Commands$(RESET)"
	@echo "$(BLUE)═══════════════════════════════════════$(RESET)"
	@echo ""
	@echo "$(BOLD)Available commands:$(RESET)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { \
		printf "  $(GREEN)%-12s$(RESET) %s\n", $$1, $$2 \
	}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)Examples:$(RESET)"
	@echo "  $(WHITE)make init$(RESET)            # Initialize development environment"
	@echo "  $(WHITE)make up$(RESET)              # Start Docker containers"
	@echo "  $(WHITE)make open$(RESET)            # Open app in browser"
	@echo "  $(WHITE)make pre-commit$(RESET)      # Run pre-commit hooks"
	@echo ""

init: ## Initialize local development environment
	@echo "$(BOLD)$(YELLOW)🔧 Initializing local development environment...$(RESET)"
	@echo "$(CYAN)Creating docker network...$(RESET)"
	@docker network create realworld-network 2>/dev/null || echo "$(YELLOW)⚠️  Network realworld-network already exists$(RESET)"
	@echo "$(CYAN)Creating .env.local file if needed...$(RESET)"
	@if [ -f ".env.local.example" ]; then \
		if [ -f ".env.local" ]; then \
			echo "$(YELLOW)⚠️  .env.local already exists (skipping)$(RESET)"; \
		else \
			cp ".env.local.example" ".env.local" && \
			echo "$(GREEN)✅ Created .env.local$(RESET)"; \
		fi; \
	else \
		echo "$(YELLOW)⚠️  No .env.local.example found$(RESET)"; \
	fi
	@echo "$(GREEN)✓ Local development environment initialized$(RESET)"

build: ## Build Docker containers
	@echo "$(BOLD)$(BLUE)🔨 Building realworld container...$(RESET)"
	@DOCKER_BUILDKIT=1 docker compose build
	@echo "$(GREEN)✓ Container built successfully$(RESET)"

up: ## Start Docker containers with dependencies
	@echo "$(BOLD)$(GREEN)🚀 Starting realworld and dependencies...$(RESET)"
	@docker compose up -d
	@echo "$(GREEN)✓ All containers started successfully$(RESET)"
	@echo "$(CYAN)💡 Access the app at http://localhost:8000/$(RESET)"

down: ## Stop Docker containers
	@echo "$(BOLD)$(RED)🛑 Stopping realworld containers...$(RESET)"
	@docker compose stop
	@echo "$(GREEN)✓ All containers stopped successfully$(RESET)"

open: ## Open RealWorld in browser
	@echo "$(BOLD)$(CYAN)🌐 Opening RealWorld at http://localhost:8000/...$(RESET)"
	@open "http://localhost:8000/"
	@echo "$(GREEN)✓ Application opened in browser$(RESET)"

shell: ## Open bash shell in container
	@RUNNING_CONTAINER=$$(docker ps --filter "name=realworld-realworld" --format "{{.Names}}" | head -1); \
	if [ -z "$$RUNNING_CONTAINER" ]; then \
		echo "$(RED)❌ No running container found$(RESET)"; \
		echo "$(YELLOW)💡 Use 'make up' to start the service first$(RESET)"; \
		exit 1; \
	else \
		echo "$(BOLD)$(YELLOW)🐚 Opening shell in $$RUNNING_CONTAINER...$(RESET)"; \
		docker exec -it $$RUNNING_CONTAINER /bin/bash 2>/dev/null || docker exec -it $$RUNNING_CONTAINER /bin/sh; \
	fi

pre-commit: ## Run pre-commit hooks after staging all files
ifeq ($(precommit_option),all)
	@echo "$(BOLD)$(MAGENTA)🔧 Running pre-commit hooks on all files...$(RESET)"
	@cd $(PROJ_DIR) && git add . && pre-commit run --all-files
else
	@echo "$(BOLD)$(MAGENTA)🔧 Running pre-commit hooks...$(RESET)"
	@cd $(PROJ_DIR) && git add . && pre-commit run
endif
	@echo "$(GREEN)✓ Pre-commit hooks completed$(RESET)"

test: ## Run unit tests with coverage
	@echo "$(BOLD)$(BLUE)🧪 Running unit tests...$(RESET)"
	@uv run pytest realworld/ -v --cov=realworld --cov-report=term-missing
	@echo "$(GREEN)✓ Unit tests completed$(RESET)"

clean: ## Clean up temporary files and caches
	@echo "$(BOLD)$(RED)🧹 Cleaning up...$(RESET)"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@find . -type f -name ".coverage" -delete 2>/dev/null || true
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)✓ Cleanup completed$(RESET)"

# Tab completion setup (add to ~/.bashrc or ~/.zshrc):
# complete -W "help pre-commit test clean all" make
