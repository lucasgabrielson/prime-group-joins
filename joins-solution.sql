--1. Get all customers and their addresses.

SELECT customers.first_name, customers.last_name, addresses.street, addresses.city, addresses.state, addresses.zip
FROM customers
JOIN addresses ON addresses.customer_id = customers.id;

--2. Get all orders and their line items (orders, quantity and product).

SELECT orders.order_date, line_items.quantity, products.description 
FROM orders
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id
ORDER BY orders.order_date;

--3. Which warehouses have cheetos?

SELECT products.description, warehouse.warehouse
FROM products
JOIN warehouse_product ON warehouse_product.product_id = products.id
JOIN warehouse ON warehouse.id = warehouse_product.warehouse_id
WHERE products.description = 'cheetos';

--4. Which warehouses have diet pepsi?

SELECT orders.order_date, products.description, warehouse.warehouse
FROM orders
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id
JOIN warehouse_product ON warehouse_product.product_id = products.id
JOIN warehouse ON warehouse.id = warehouse_product.warehouse_id
WHERE products.description = 'diet pepsi'
ORDER BY orders.order_date;

--5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.

SELECT customers.first_name AS "First Name" , customers.last_name AS "Last Name", COUNT(orders.id) AS "Total Orders"
FROM customers
JOIN addresses ON addresses.customer_id = customers.id
JOIN orders ON orders.address_id = addresses.id
GROUP BY customers.first_name, customers.last_name
ORDER BY COUNT(orders.id) DESC;

--6. How many customers do we have?

SELECT COUNT(customers.id) AS "Total Customers"
FROM customers;

--7. How many products do we carry?

SELECT COUNT(products.id) AS "Total Products"
FROM customers
JOIN addresses ON addresses.customer_id = customers.id
JOIN orders ON orders.address_id = addresses.id
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id;

--8. What is the total available on-hand quantity of diet pepsi?

SELECT products.description AS "Product", SUM(warehouse_product.on_hand) AS "Total On Hand"
FROM products
JOIN warehouse_product ON warehouse_product.product_id = products.id
JOIN warehouse ON warehouse.id = warehouse_product.warehouse_id
WHERE products.description = 'diet pepsi'
GROUP BY products.description;


--
--9. How much was the total cost for each order?

SELECT line_items.order_id, SUM(line_items.quantity * products.unit_price)
FROM addresses
JOIN orders ON orders.address_id = addresses.id
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON line_items.product_id = products.id
GROUP BY line_items.order_id
ORDER BY line_items.order_id;