# 📚 Documentación de APIs - FTGO Monolith

Esta documentación describe todas las rutas y endpoints disponibles en la aplicación FTGO Monolith, una aplicación de entrega de comida construida con Spring Boot.

## 🌐 URL Base
```
http://localhost:8081
```

## 📋 Índice de Servicios

- [🧑‍💼 Consumer Service](#-consumer-service) - Gestión de consumidores/clientes
- [🚚 Courier Service](#-courier-service) - Gestión de repartidores
- [📦 Order Service](#-order-service) - Gestión de pedidos
- [🏪 Restaurant Service](#-restaurant-service) - Gestión de restaurantes
- [🔍 Endpoints Adicionales](#-endpoints-adicionales) - Health checks y documentación

---

## 🧑‍💼 Consumer Service

Gestiona la información de los consumidores/clientes de la aplicación.

### Crear Consumer
**POST** `/consumers`

Crea un nuevo consumidor en el sistema.

**Request Body:**
```json
{
  "name": {
    "firstName": "string",
    "lastName": "string"
  }
}
```

**Response:**
```json
{
  "consumerId": 123
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/consumers \
  -H "Content-Type: application/json" \
  -d '{
    "name": {
      "firstName": "Juan",
      "lastName": "Pérez"
    }
  }'
```

### Obtener Consumer
**GET** `/consumers/{consumerId}`

Obtiene la información de un consumidor específico.

**Parámetros:**
- `consumerId` (path) - ID del consumidor

**Response:**
```json
{
  "name": {
    "firstName": "string",
    "lastName": "string"
  }
}
```

**Ejemplo:**
```bash
curl http://localhost:8081/consumers/1
```

---

## 🚚 Courier Service

Gestiona la información y disponibilidad de los repartidores.

### Crear Courier
**POST** `/couriers`

Crea un nuevo repartidor en el sistema.

**Request Body:**
```json
{
  "name": {
    "firstName": "string",
    "lastName": "string"
  },
  "address": "string"
}
```

**Response:**
```json
{
  "courierId": 123
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/couriers \
  -H "Content-Type: application/json" \
  -d '{
    "name": {
      "firstName": "Carlos",
      "lastName": "Rodríguez"
    },
    "address": "Av. Principal 123"
  }'
```

### Obtener Courier
**GET** `/couriers/{courierId}`

Obtiene la información de un repartidor específico.

**Parámetros:**
- `courierId` (path) - ID del repartidor

**Response:**
```json
{
  "id": 123,
  "name": {
    "firstName": "string",
    "lastName": "string"
  },
  "address": "string",
  "available": true
}
```

**Ejemplo:**
```bash
curl http://localhost:8081/couriers/1
```

### Actualizar Disponibilidad del Courier
**POST** `/couriers/{courierId}/availability`

Actualiza la disponibilidad de un repartidor.

**Parámetros:**
- `courierId` (path) - ID del repartidor

**Request Body:**
```json
{
  "available": true
}
```

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/couriers/1/availability \
  -H "Content-Type: application/json" \
  -d '{"available": true}'
```

---

## 📦 Order Service

Gestiona todo el ciclo de vida de los pedidos, desde la creación hasta la entrega.

### Crear Pedido
**POST** `/orders`

Crea un nuevo pedido en el sistema.

**Request Body:**
```json
{
  "consumerId": 123,
  "restaurantId": 456,
  "lineItems": [
    {
      "menuItemId": "ITEM_001",
      "quantity": 2
    },
    {
      "menuItemId": "ITEM_002",
      "quantity": 1
    }
  ]
}
```

**Response:**
```json
{
  "orderId": 789
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders \
  -H "Content-Type: application/json" \
  -d '{
    "consumerId": 1,
    "restaurantId": 1,
    "lineItems": [
      {
        "menuItemId": "PIZZA_MARGHERITA",
        "quantity": 1
      }
    ]
  }'
```

### Obtener Pedido
**GET** `/orders/{orderId}`

Obtiene la información detallada de un pedido específico.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:**
```json
{
  "id": 789,
  "orderState": "PENDING",
  "orderTotal": 25.99,
  "restaurantName": "Pizza Palace",
  "assignedCourierId": 123,
  "courierActions": [
    {
      "action": "PICKUP",
      "address": "Restaurant Address"
    }
  ]
}
```

**Ejemplo:**
```bash
curl http://localhost:8081/orders/1
```

### Obtener Pedidos por Consumer
**GET** `/orders?consumerId={consumerId}`

Obtiene todos los pedidos de un consumidor específico.

**Parámetros:**
- `consumerId` (query) - ID del consumidor

**Response:**
```json
[
  {
    "id": 789,
    "orderState": "DELIVERED",
    "orderTotal": 25.99,
    "restaurantName": "Pizza Palace",
    "assignedCourierId": 123,
    "courierActions": []
  }
]
```

**Ejemplo:**
```bash
curl "http://localhost:8081/orders?consumerId=1"
```

### Cancelar Pedido
**POST** `/orders/{orderId}/cancel`

Cancela un pedido existente.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:**
```json
{
  "id": 789,
  "orderState": "CANCELLED",
  "orderTotal": 25.99,
  "restaurantName": "Pizza Palace",
  "assignedCourierId": null,
  "courierActions": []
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/cancel
```

### Revisar Pedido
**POST** `/orders/{orderId}/revise`

Modifica las cantidades de los items en un pedido.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Request Body:**
```json
{
  "revisedLineItemQuantities": {
    "ITEM_001": 3,
    "ITEM_002": 0
  }
}
```

**Response:** Información actualizada del pedido

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/revise \
  -H "Content-Type: application/json" \
  -d '{
    "revisedLineItemQuantities": {
      "PIZZA_MARGHERITA": 2
    }
  }'
```

### Aceptar Pedido (Restaurante)
**POST** `/orders/{orderId}/accept`

El restaurante acepta el pedido y establece el tiempo estimado de preparación.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Request Body:**
```json
{
  "readyBy": "2024-01-15T18:30:00"
}
```

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/accept \
  -H "Content-Type: application/json" \
  -d '{"readyBy": "2024-01-15T18:30:00"}'
```

### Marcar como Preparando
**POST** `/orders/{orderId}/preparing`

Indica que el restaurante está preparando el pedido.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/preparing
```

### Marcar como Listo
**POST** `/orders/{orderId}/ready`

Indica que el pedido está listo para recoger.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/ready
```

### Marcar como Recogido
**POST** `/orders/{orderId}/pickedup`

Indica que el repartidor ha recogido el pedido.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/pickedup
```

### Marcar como Entregado
**POST** `/orders/{orderId}/delivered`

Indica que el pedido ha sido entregado al cliente.

**Parámetros:**
- `orderId` (path) - ID del pedido

**Response:** `200 OK`

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/orders/1/delivered
```

---

## 🏪 Restaurant Service

Gestiona la información de los restaurantes y sus menús.

### Crear Restaurant
**POST** `/restaurants`

Crea un nuevo restaurante en el sistema.

**Request Body:**
```json
{
  "name": "string",
  "address": {
    "street1": "string",
    "street2": "string",
    "city": "string",
    "state": "string",
    "zip": "string"
  },
  "menu": {
    "menuItems": [
      {
        "id": "string",
        "name": "string",
        "price": 19.99
      }
    ]
  }
}
```

**Response:**
```json
{
  "restaurantId": 456
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:8081/restaurants \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Pizza Palace",
    "address": {
      "street1": "123 Main St",
      "city": "Ciudad",
      "state": "Estado",
      "zip": "12345"
    },
    "menu": {
      "menuItems": [
        {
          "id": "PIZZA_MARGHERITA",
          "name": "Pizza Margherita",
          "price": 15.99
        }
      ]
    }
  }'
```

### Obtener Restaurant
**GET** `/restaurants/{restaurantId}`

Obtiene la información de un restaurante específico.

**Parámetros:**
- `restaurantId` (path) - ID del restaurante

**Response:**
```json
{
  "id": 456,
  "name": "Pizza Palace"
}
```

**Ejemplo:**
```bash
curl http://localhost:8081/restaurants/1
```

---

## 🔍 Endpoints Adicionales

### Health Check
**GET** `/actuator/health`

Verifica el estado de salud de la aplicación.

**Response:**
```json
{
  "status": "UP"
}
```

**Ejemplo:**
```bash
curl http://localhost:8081/actuator/health
```

### Documentación Swagger
**GET** `/swagger-ui.html`

Accede a la interfaz web de Swagger para explorar y probar las APIs interactivamente.

**URL:** http://localhost:8081/swagger-ui.html

---

## 🔄 Estados de Pedido

Los pedidos pasan por los siguientes estados durante su ciclo de vida:

1. **PENDING** - Pedido creado, esperando aceptación del restaurante
2. **ACCEPTED** - Restaurante acepta el pedido
3. **PREPARING** - Restaurante está preparando el pedido
4. **READY_FOR_PICKUP** - Pedido listo para recoger
5. **PICKED_UP** - Repartidor recoge el pedido
6. **DELIVERED** - Pedido entregado al cliente
7. **CANCELLED** - Pedido cancelado

## 🧪 Scripts de Prueba

El proyecto incluye un script para probar todas las APIs:

```bash
./test-api.sh
```

Este script ejecuta una serie de pruebas automatizadas que:
- Crea consumidores, restaurantes y repartidores
- Crea pedidos de prueba
- Simula el flujo completo de un pedido
- Verifica que todos los endpoints funcionen correctamente

## 🚨 Códigos de Error

- **200 OK** - Operación exitosa
- **404 NOT FOUND** - Recurso no encontrado
- **400 BAD REQUEST** - Datos de entrada inválidos
- **500 INTERNAL SERVER ERROR** - Error interno del servidor

## 💡 Consejos de Uso

1. **Orden de Creación**: Crea primero consumidores y restaurantes antes de crear pedidos
2. **IDs Secuenciales**: Los IDs se generan secuencialmente comenzando desde 1
3. **Estados**: Respeta el flujo de estados de los pedidos para evitar errores
4. **Datos de Prueba**: La aplicación carga datos de ejemplo automáticamente al iniciar

---

**📝 Nota:** Esta documentación está basada en el análisis del código fuente del proyecto FTGO Monolith. Para obtener la información más actualizada, consulta la documentación Swagger en `/swagger-ui.html` cuando la aplicación esté ejecutándose.
