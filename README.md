# 🍕 FTGO Monolith - Food To Go Application

[![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://www.docker.com/)
[![Java](https://img.shields.io/badge/Java-8+-orange?logo=java)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.0.3-green?logo=spring)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)](https://www.mysql.com/)
[![Multi-Architecture](https://img.shields.io/badge/Multi--Arch-ARM64%20%7C%20x86-purple)](https://github.com/rafaelpatinogoji-demo-org/ftgo-monolith)

A complete monolithic Spring Boot application demonstrating a food delivery service. This is the monolithic version of the [FTGO application](https://github.com/microservices-patterns/ftgo-application) from the book [Microservices Patterns](https://microservices.io/book).

## 🚀 Quick Start

**TL;DR**: Just run this command and you're done!

```bash
./build-and-run-auto.sh
```

That's it! The script will:
- ✅ Detect your system architecture (ARM64/x86_64)
- ✅ Compile the Java application
- ✅ Build Docker images
- ✅ Start MySQL database
- ✅ Launch the application
- ✅ Load sample data
- ✅ Show you the access URLs

## 📋 Prerequisites

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop)
- **Java 8+** - Check with `java -version`

### Installation Commands (macOS)
```bash
# Install Java (if needed)
brew install openjdk@11

# Install Docker Desktop from the website above
```

## 🏗️ Architecture Support

This project supports both:
- **🍎 Apple Silicon (M1/M2/M3)** - ARM64 architecture
- **💻 Intel/AMD** - x86_64 architecture

The build script automatically detects your architecture and uses the appropriate configuration.

## 🌐 Access Your Application

Once running, you can access:

| Service | URL | Description |
|---------|-----|-------------|
| **Main Application** | http://localhost:8081 | FTGO web application |
| **Health Check** | http://localhost:8081/actuator/health | Application status |
| **Swagger UI** | http://localhost:8081/swagger-ui.html | API documentation |
| **MySQL Database** | localhost:3306 | Database (user: `mysqluser`, pass: `mysqlpw`) |

## 🧪 Testing the Application

Once running, you can test the API endpoints:

```bash
# Check application health
curl http://localhost:8081/actuator/health

# Create a consumer
curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "John", "lastName": "Doe"}}'

# Get a consumer
curl http://localhost:8081/consumers/1

# Run complete API tests
./test-api.sh
```

### 🗄️ Database Schema

The application automatically creates all necessary tables on startup:
- **consumers** - Customer information
- **restaurants** - Restaurant details and menus  
- **orders** - Order management
- **courier** - Delivery personnel
- **courier_actions** - Delivery tracking
- **order_line_items** - Order details

Sample data is automatically loaded including:
- 3 sample couriers
- 3 sample restaurants with menu items
- Hibernate sequence table for ID generation

## 🛠️ Manual Commands

If you prefer more control over individual steps:

```bash
# Compile the application
./gradlew :ftgo-application:assemble

# Build Docker images (ARM64)
docker-compose -f docker-compose-arm64.yml build

# Start services (ARM64)
docker-compose -f docker-compose-arm64.yml up -d

# View logs
docker-compose -f docker-compose-arm64.yml logs -f

# Stop services
docker-compose -f docker-compose-arm64.yml down
```

## 📁 Project Structure

```
ftgo-monolith/
├── 🚀 build-and-run-auto.sh          # Main script (auto-detects architecture)
├── 📊 load-sample-data.sh             # Sample data loader
├── 🧪 test-api.sh                     # API testing suite
├── 🐳 docker-compose-arm64.yml       # ARM64 configuration
├── 🐳 docker-compose-x86.yml         # x86 configuration
├── 📱 ftgo-application/               # Main Spring Boot app
├── 🗄️ mysql/                         # Database configuration & schemas
├── 🛍️ ftgo-order-service/            # Order management
├── 🏪 ftgo-restaurant-service/       # Restaurant management
├── 🚚 ftgo-courier-service/          # Delivery management
├── 👤 ftgo-consumer-service/         # Customer management
├── 📋 COMMANDS.md                     # Useful commands reference
└── 📖 README.adoc                     # Detailed documentation
```

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Check what's using port 3306
lsof -i :3306

# Stop local MySQL if running
brew services stop mysql
```

### Permission Denied
```bash
# Make scripts executable
chmod +x *.sh
```

### Docker Issues
- Make sure Docker Desktop is running (look for 🐳 in your menu bar)
- Try restarting Docker Desktop
- Check available disk space

### Build Failures
```bash
# Clean and rebuild
./gradlew clean
./build-and-run-auto.sh
```

## 🎯 What This Application Demonstrates

- **Monolithic Architecture**: Single deployable unit
- **Spring Boot**: Modern Java web framework
- **JPA/Hibernate**: Database ORM with automatic schema generation
- **MySQL**: Relational database with sample data
- **Docker**: Multi-architecture containerization
- **RESTful APIs**: HTTP-based services
- **Domain-Driven Design**: Business logic organization
- **Automated Setup**: One-command deployment

## 📚 Learn More

- 📖 [Microservices Patterns Book](https://microservices.io/book)
- 🌐 [Refactoring to Microservices](https://microservices.io/refactoring/index.html)
- 🔗 [Original Microservices Version](https://github.com/microservices-patterns/ftgo-application)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test with `./build-and-run-auto.sh`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📄 License

This project is part of the Microservices Patterns book examples.

---

**Happy coding! 🎉**

*If you encounter any issues, check the troubleshooting section above or create an issue in the repository.*
