-- 1. Переносим продукты (объединяем product и product_info)
INSERT INTO product_new (id, name, picture_url, price)
SELECT p.id, p.name, p.picture_url, pi.price
FROM product p
JOIN product_info pi ON p.id = pi.product_id;

-- 2. Переносим заказы (объединяем orders и orders_date)
INSERT INTO orders_new (id, status, date_created)
SELECT o.id, o.status, od.date_created
FROM orders o
JOIN orders_date od ON o.id = od.order_id;

-- 3. Переносим связи заказ-товар (добавляем quantity, если её не было – она есть)
INSERT INTO order_product_new (order_id, product_id, quantity)
SELECT order_id, product_id, quantity
FROM order_product;

-- 4. Удаляем старые таблицы
DROP TABLE order_product;
DROP TABLE orders_date;
DROP TABLE orders;
DROP TABLE product_info;
DROP TABLE product;

-- 5. Переименовываем новые таблицы в итоговые имена
ALTER TABLE product_new RENAME TO product;
ALTER TABLE orders_new RENAME TO orders;
ALTER TABLE order_product_new RENAME TO order_product;