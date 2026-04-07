-- Таблица продуктов (объединяет product и product_info)
CREATE TABLE product (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    picture_url TEXT,
    price       NUMERIC(10,2) NOT NULL
);

-- Таблица заказов (объединяет orders и orders_date)
CREATE TABLE orders (
    id           INTEGER PRIMARY KEY,
    status       VARCHAR(50) NOT NULL,
    date_created TIMESTAMP NOT NULL
);

-- Таблица связей заказов и продуктов
CREATE TABLE order_product (
    order_id   INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES product(id),
    PRIMARY KEY (order_id, product_id)
);