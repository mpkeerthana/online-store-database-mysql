CREATE DATABASE IF NOT EXISTS online_store;
USE online_store;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products_details;
DROP TABLE IF EXISTS customers_details;

CREATE TABLE customers_details(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name_of_the_customer VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products_details(
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
	price DECIMAL(10,4) NOT NULL CHECK(price>0),
    stock INT NOT NULL CHECK(stock>=0)
);

CREATE TABLE orders(
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_of_the_order ENUM('Placed','Shipped','Delivered','Cancelled') DEFAULT 'Placed',
    FOREIGN KEY (customer_id) REFERENCES customers_details(customer_id)
);

CREATE TABLE order_items(
	order_items_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK(quantity>0),
    price INT NOT NULL CHECK(price>0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products_details(product_id)
);

CREATE TABLE payments(
	payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Card','UPI','NetBanking','Cash'),
    payment_status ENUM('Success','Failed','Pending') DEFAULT 'Success',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO customers_details(name_of_the_customer,email,phone)
VALUES 
('Rahul', 'rahul@gmail.com', '9876543210'),
('Anu', 'anu@gmail.com', '9123456780');

INSERT INTO products_details (product_name, price, stock)
VALUES
('Laptop', 55000, 10),
('Mouse', 500, 50),
('Keyboard', 1200, 30);

INSERT INTO orders (customer_id, status_of_the_order)
VALUES 
(1, 'Placed');

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 55000),
(1, 2, 2, 500);

INSERT INTO payments (order_id, amount, payment_method)
VALUES (1, 56000, 'UPI');

UPDATE orders
SET status_of_the_order = 'Shipped'
WHERE order_id = 1;

SELECT * FROM orders WHERE customer_id = 1;

SELECT SUM(amount) AS total_sale
FROM payments
WHERE payment_status='Success';

SELECT c.name_of_the_customer, SUM(p.amount) AS total_spent
FROM customers_details c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;

SELECT pr.product_name, SUM(oi.quantity) AS total_sold
FROM products pr
JOIN order_items oi ON pr.product_id = oi.product_id
GROUP BY pr.product_id
ORDER BY total_sold DESC;

