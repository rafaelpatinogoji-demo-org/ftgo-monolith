#!/bin/bash -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}🚀 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🍕 FTGO MONOLITH 🍕                      ║"
echo "║              Food To Go - Auto Setup Script                 ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check prerequisites
print_step "Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    print_info "Please install Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    print_error "Docker is not running!"
    print_info "Please start Docker Desktop and try again"
    exit 1
fi

# Check Java
if ! command -v java &> /dev/null; then
    print_error "Java is not installed!"
    print_info "Please install Java 8+: brew install openjdk@11"
    exit 1
fi

print_success "All prerequisites are met!"

# Detect architecture
print_step "Detecting system architecture..."
ARCH=$(uname -m)
print_info "Architecture detected: $ARCH"

# Determine which configuration to use
if [[ "$ARCH" == "arm64" ]]; then
    print_success "🍎 Apple Silicon (M1/M2/M3) detected"
    COMPOSE_FILE="docker-compose-arm64.yml"
elif [[ "$ARCH" == "x86_64" ]]; then
    print_success "💻 Intel/AMD x86_64 detected"
    COMPOSE_FILE="docker-compose-x86.yml"
else
    print_error "Unsupported architecture: $ARCH"
    print_info "Please use the appropriate docker-compose file manually:"
    print_info "  - For Apple Silicon: docker-compose -f docker-compose-arm64.yml up -d"
    print_info "  - For Intel/AMD:     docker-compose -f docker-compose-x86.yml up -d"
    exit 1
fi

print_step "Starting FTGO application..."
print_info "This may take a few minutes on first run..."

# Set environment variables
. ./set-env.sh

# Build the application
print_step "📦 Compiling Java application..."
if ./gradlew :ftgo-application:assemble; then
    print_success "Application compiled successfully!"
else
    print_error "Failed to compile application"
    exit 1
fi

# Build Docker images
print_step "🐳 Building Docker images..."
if docker-compose -f "$COMPOSE_FILE" build; then
    print_success "Docker images built successfully!"
else
    print_error "Failed to build Docker images"
    exit 1
fi

# Stop any existing services
print_step "🛑 Stopping existing services..."
docker-compose -f "$COMPOSE_FILE" down -v

# Start services
print_step "🚀 Starting services..."
if docker-compose -f "$COMPOSE_FILE" up -d; then
    print_success "Services started successfully!"
else
    print_error "Failed to start services"
    exit 1
fi

# Wait for services to be ready
print_step "⏳ Waiting for services to be ready..."
print_info "This may take a moment..."

# Wait for application to be healthy
for i in {1..30}; do
    if curl -f http://localhost:8081/actuator/health >/dev/null 2>&1; then
        print_success "Application is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "Application failed to start within expected time"
        print_info "Check logs with: docker-compose -f $COMPOSE_FILE logs -f"
        exit 1
    fi
    echo -n "."
    sleep 10
done

# Load sample data
print_step "📊 Loading sample data..."
if ./load-sample-data.sh; then
    print_success "Sample data loaded successfully!"
else
    print_warning "Failed to load sample data, but application is running"
fi

# If we get here, everything worked
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    🎉 SUCCESS! 🎉                           ║${NC}"
echo -e "${GREEN}║              FTGO Application is running!                   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
print_success "🌐 Application URL:    http://localhost:8081"
print_success "💚 Health Check:       http://localhost:8081/actuator/health"
print_success "📚 API Documentation:  http://localhost:8081/swagger-ui.html"
print_success "🗄️  MySQL Database:     localhost:3306 (user: mysqluser, pass: mysqlpw)"
echo ""
print_info "📋 Useful commands:"
echo -e "   ${CYAN}View logs:${NC}    docker-compose -f $COMPOSE_FILE logs -f"
echo -e "   ${CYAN}Stop app:${NC}     docker-compose -f $COMPOSE_FILE down"
echo -e "   ${CYAN}Restart:${NC}      docker-compose -f $COMPOSE_FILE restart"
echo ""
print_info "🧪 Test the API:"
echo -e "   ${CYAN}curl http://localhost:8081/consumers/1${NC}"
echo -e "   ${CYAN}curl -X POST http://localhost:8081/consumers -H 'Content-Type: application/json' -d '{\"name\": {\"firstName\": \"Test\", \"lastName\": \"User\"}}'${NC}"
echo ""
else
    print_error "Failed to start FTGO application"
    print_info "Check the logs above for error details"
    print_info "Common solutions:"
    print_info "  - Make sure ports 3306 and 8081 are not in use"
    print_info "  - Restart Docker Desktop"
    print_info "  - Run: docker system prune -f"
    exit 1
fi
