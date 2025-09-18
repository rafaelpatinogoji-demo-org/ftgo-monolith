#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🍕 Loading sample data into FTGO application...${NC}"

# Wait for application to be ready
echo -e "${CYAN}⏳ Waiting for application to be ready...${NC}"
for i in {1..30}; do
    if curl -f http://localhost:8081/actuator/health >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Application is ready!${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${RED}❌ Application not ready after 5 minutes${NC}"
        exit 1
    fi
    sleep 10
done

echo -e "${BLUE}👥 Creating sample consumers...${NC}"

# Create consumers
curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "John", "lastName": "Doe"}}' \
  -s > /dev/null && echo -e "${GREEN}✅ Created consumer: John Doe${NC}"

curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "Jane", "lastName": "Smith"}}' \
  -s > /dev/null && echo -e "${GREEN}✅ Created consumer: Jane Smith${NC}"

curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "Carlos", "lastName": "Rodriguez"}}' \
  -s > /dev/null && echo -e "${GREEN}✅ Created consumer: Carlos Rodriguez${NC}"

curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "Alice", "lastName": "Johnson"}}' \
  -s > /dev/null && echo -e "${GREEN}✅ Created consumer: Alice Johnson${NC}"

echo -e "${BLUE}🏪 Adding sample restaurants directly to database...${NC}"

# Add restaurants and couriers directly to database
docker exec ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo -e "
INSERT IGNORE INTO restaurants (id, name, city, state) VALUES 
(1, 'Pizza Palace', 'San Francisco', 'CA'),
(2, 'Burger Barn', 'San Francisco', 'CA'),
(3, 'Taco Town', 'San Francisco', 'CA');

INSERT IGNORE INTO restaurant_menu_items (restaurant_id, id, name, price) VALUES 
(1, 'pizza-margherita', 'Margherita Pizza', 12.99),
(1, 'pizza-pepperoni', 'Pepperoni Pizza', 14.99),
(2, 'burger-classic', 'Classic Burger', 9.99),
(2, 'burger-cheese', 'Cheeseburger', 10.99),
(3, 'taco-beef', 'Beef Taco', 3.99),
(3, 'taco-chicken', 'Chicken Taco', 4.99);

INSERT IGNORE INTO courier (id, available, first_name, last_name, city, state) VALUES 
(1, 1, 'Mike', 'Johnson', 'San Francisco', 'CA'),
(2, 1, 'Sarah', 'Wilson', 'San Francisco', 'CA'),
(3, 0, 'David', 'Brown', 'San Francisco', 'CA');
" 2>/dev/null

echo -e "${GREEN}✅ Added sample restaurants and couriers${NC}"

echo ""
echo -e "${GREEN}🎉 Sample data loaded successfully!${NC}"
echo ""
echo -e "${CYAN}📋 You can now test:${NC}"
echo -e "   ${CYAN}• Consumers:${NC} curl http://localhost:8081/consumers/1"
echo -e "   ${CYAN}• Database:${NC}  docker exec ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo -e 'SELECT * FROM consumers;'"
echo ""
