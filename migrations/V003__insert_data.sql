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


-- тут генерация данных для новой схемы
-- Вставляем продукты 
INSERT INTO product (id, name, picture_url, price) VALUES
(1, 'Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
(2, 'Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
(3, 'Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
(4, 'Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
(5, 'Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
(6, 'Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);


INSERT INTO orders (id, status, date_created)
SELECT i,
       (array['pending', 'shipped', 'cancelled'])[floor(random() * 3 + 1)],
       DATE(NOW() - (random() * (NOW()+'90 days' - NOW())))
FROM generate_series(1, 10000000) s(i);

 
INSERT INTO order_product (order_id, product_id, quantity)
SELECT i,
       1 + floor(random()*6)::int % 6,
       floor(1+random()*50)::int
FROM generate_series(1, 10000000) s(i);