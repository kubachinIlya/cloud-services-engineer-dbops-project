CREATE INDEX order_product_order_id_idx ON order_product(order_id); 


CREATE INDEX orders_date_status_idx ON orders(date_created, status);