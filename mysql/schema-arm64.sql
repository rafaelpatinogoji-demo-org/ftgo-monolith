-- Schema completo para FTGO - ARM64
-- La base de datos 'ftgo' ya se crea automáticamente

-- Crear todas las tablas necesarias
CREATE TABLE IF NOT EXISTS consumers (
    id bigint NOT NULL,
    first_name varchar(255),
    last_name varchar(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS courier (
    id bigint NOT NULL AUTO_INCREMENT,
    available bit,
    first_name varchar(255),
    last_name varchar(255),
    street1 varchar(255),
    street2 varchar(255),
    city varchar(255),
    state varchar(255),
    zip varchar(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS courier_actions (
    courier_id bigint NOT NULL,
    order_id bigint,
    time datetime,
    type varchar(255)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hibernate_sequence (
    next_val bigint
) ENGINE=InnoDB;

-- Insertar valor inicial para la secuencia
INSERT INTO hibernate_sequence (next_val) VALUES (1) 
ON DUPLICATE KEY UPDATE next_val = GREATEST(next_val, 1);

CREATE TABLE IF NOT EXISTS order_line_items (
    order_id bigint NOT NULL,
    menu_item_id varchar(255),
    name varchar(255),
    price decimal(19,2),
    quantity integer NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    id bigint NOT NULL AUTO_INCREMENT,
    accept_time datetime,
    consumer_id bigint,
    delivery_address_city varchar(255),
    delivery_address_state varchar(255),
    delivery_address_street1 varchar(255),
    delivery_address_street2 varchar(255),
    delivery_address_zip varchar(255),
    delivery_time datetime,
    order_state varchar(255),
    order_minimum decimal(19,2),
    payment_token varchar(255),
    picked_up_time datetime,
    delivered_time datetime,
    preparing_time datetime,
    previous_ticket_state integer,
    ready_by datetime,
    ready_for_pickup_time datetime,
    version bigint,
    assigned_courier_id bigint,
    restaurant_id bigint,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS restaurant_menu_items (
    restaurant_id bigint NOT NULL,
    id varchar(255),
    name varchar(255),
    price decimal(19,2)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS restaurants (
    id bigint NOT NULL AUTO_INCREMENT,
    name varchar(255),
    street1 varchar(255),
    street2 varchar(255),
    city varchar(255),
    state varchar(255),
    zip varchar(255),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Crear índices y claves foráneas solo si no existen
-- (MySQL no tiene IF NOT EXISTS para constraints, así que usamos un enfoque seguro)

-- Insertar datos de ejemplo
INSERT IGNORE INTO courier (id, available, first_name, last_name, city, state) VALUES 
(1, 1, 'Mike', 'Johnson', 'San Francisco', 'CA'),
(2, 1, 'Sarah', 'Wilson', 'San Francisco', 'CA'),
(3, 0, 'David', 'Brown', 'San Francisco', 'CA');

INSERT IGNORE INTO restaurants (id, name, city, state) VALUES 
(1, 'Pizza Palace', 'San Francisco', 'CA'),
(2, 'Burger Barn', 'San Francisco', 'CA'),
(3, 'Taco Town', 'San Francisco', 'CA');

-- Insertar items de menú de ejemplo
INSERT IGNORE INTO restaurant_menu_items (restaurant_id, id, name, price) VALUES 
(1, 'pizza-margherita', 'Margherita Pizza', 12.99),
(1, 'pizza-pepperoni', 'Pepperoni Pizza', 14.99),
(2, 'burger-classic', 'Classic Burger', 9.99),
(2, 'burger-cheese', 'Cheeseburger', 10.99),
(3, 'taco-beef', 'Beef Taco', 3.99),
(3, 'taco-chicken', 'Chicken Taco', 4.99);

-- Permisos
GRANT ALL PRIVILEGES ON ftgo.* TO 'mysqluser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
