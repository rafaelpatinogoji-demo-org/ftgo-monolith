# 🛠️ FTGO Useful Commands

## 🚀 Quick Start
```bash
./build-and-run-auto.sh
```

## 🔍 Check Status
```bash
# Check if services are running
docker-compose -f docker-compose-arm64.yml ps    # ARM64
docker-compose -f docker-compose-x86.yml ps      # x86

# Check application health
curl http://localhost:8081/actuator/health
```

## 📋 View Logs
```bash
# All services
docker-compose -f docker-compose-arm64.yml logs -f

# Just the application
docker-compose -f docker-compose-arm64.yml logs -f ftgo-application

# Just MySQL
docker-compose -f docker-compose-arm64.yml logs -f mysql
```

## 🛑 Stop/Start Services
```bash
# Stop all services
docker-compose -f docker-compose-arm64.yml down

# Stop and remove volumes (clean slate)
docker-compose -f docker-compose-arm64.yml down -v

# Start services
docker-compose -f docker-compose-arm64.yml up -d

# Restart a specific service
docker-compose -f docker-compose-arm64.yml restart ftgo-application
```

## 🧪 API Testing
```bash
# Health check
curl http://localhost:8081/actuator/health

# Create a consumer
curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": "John Doe"}'

# Get all consumers
curl http://localhost:8081/consumers

# Create a restaurant
curl -X POST http://localhost:8081/restaurants \
  -H "Content-Type: application/json" \
  -d '{"name": "Pizza Palace", "menu": []}'

# Get all restaurants
curl http://localhost:8081/restaurants
```

## 🗄️ Database Access
```bash
# Connect to MySQL
docker exec -it ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo

# Or using local MySQL client
mysql -h localhost -P 3306 -u mysqluser -pmysqlpw ftgo
```

## 🧹 Cleanup
```bash
# Remove all containers and volumes
docker-compose -f docker-compose-arm64.yml down -v

# Clean up Docker system
docker system prune -f

# Remove all unused images
docker image prune -a -f
```

## 🔧 Development
```bash
# Rebuild just the application
./gradlew :ftgo-application:assemble
docker-compose -f docker-compose-arm64.yml build ftgo-application
docker-compose -f docker-compose-arm64.yml up -d ftgo-application

# Run tests
./gradlew test

# Clean build
./gradlew clean build
```

## 🐛 Troubleshooting
```bash
# Check what's using port 3306
lsof -i :3306

# Check what's using port 8081
lsof -i :8081

# Kill process on port
kill -9 $(lsof -ti:3306)

# Check Docker status
docker info

# Restart Docker (macOS)
killall Docker && open /Applications/Docker.app
```
