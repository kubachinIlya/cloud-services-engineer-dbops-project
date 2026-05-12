-- Таблица продуктов с ценой
CREATE TABLE product_new (
    id bigint PRIMARY KEY,
    name varchar(255) NOT NULL,
    picture_url varchar(255),
    price double precision NOT NULL
);

-- Таблица заказов с датой
CREATE TABLE orders_new (
    id bigint PRIMARY KEY,
    status varchar(255) NOT NULL,
    date_created date NOT NULL
);

-- Таблица связей с количеством
CREATE TABLE order_product_new (
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    PRIMARY KEY (order_id, product_id)
);