#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Testing FTGO API endpoints...${NC}"
echo ""

# Test 1: Health Check
echo -e "${CYAN}1. Health Check${NC}"
HEALTH=$(curl -s http://localhost:8081/actuator/health)
if [[ $HEALTH == *"UP"* ]]; then
    echo -e "${GREEN}✅ Application is healthy${NC}"
else
    echo -e "${RED}❌ Application is not healthy${NC}"
    exit 1
fi
echo ""

# Test 2: Get existing consumer
echo -e "${CYAN}2. Get Consumer (ID: 2)${NC}"
CONSUMER=$(curl -s http://localhost:8081/consumers/2)
echo -e "${YELLOW}Response:${NC} $CONSUMER"
echo ""

# Test 3: Create new consumer
echo -e "${CYAN}3. Create New Consumer${NC}"
NEW_CONSUMER=$(curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{"name": {"firstName": "Test", "lastName": "User"}}' \
  -s)
echo -e "${YELLOW}Response:${NC} $NEW_CONSUMER"
echo ""

# Test 4: Get the new consumer
if [[ $NEW_CONSUMER == *"consumerId"* ]]; then
    CONSUMER_ID=$(echo $NEW_CONSUMER | grep -o '"consumerId":[0-9]*' | grep -o '[0-9]*')
    echo -e "${CYAN}4. Get New Consumer (ID: $CONSUMER_ID)${NC}"
    GET_NEW_CONSUMER=$(curl -s http://localhost:8081/consumers/$CONSUMER_ID)
    echo -e "${YELLOW}Response:${NC} $GET_NEW_CONSUMER"
    echo ""
fi

# Test 5: Database verification
echo -e "${CYAN}5. Database Verification${NC}"
echo -e "${YELLOW}Consumers in database:${NC}"
docker exec ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo -e "SELECT id, first_name, last_name FROM consumers ORDER BY id;" 2>/dev/null
echo ""

echo -e "${YELLOW}Restaurants in database:${NC}"
docker exec ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo -e "SELECT id, name, city FROM restaurants;" 2>/dev/null
echo ""

echo -e "${YELLOW}Menu items in database:${NC}"
docker exec ftgo-monolith-mysql-1 mysql -u mysqluser -pmysqlpw ftgo -e "SELECT restaurant_id, name, price FROM restaurant_menu_items ORDER BY restaurant_id;" 2>/dev/null
echo ""

echo -e "${GREEN}🎉 API testing completed!${NC}"
echo ""
echo -e "${CYAN}📋 Try these commands yourself:${NC}"
echo -e "   ${CYAN}curl http://localhost:8081/consumers/1${NC}"
echo -e "   ${CYAN}curl -X POST http://localhost:8081/consumers -H 'Content-Type: application/json' -d '{\"name\": {\"firstName\": \"Your\", \"lastName\": \"Name\"}}'${NC}"
echo ""
