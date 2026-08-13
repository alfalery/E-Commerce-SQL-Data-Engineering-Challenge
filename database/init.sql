CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(255) PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(50),
    customer_city VARCHAR(255),
    customer_state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS geolocation (
    geolocation_zip_code_prefix VARCHAR(50),
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC,
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date TIMESTAMP,
    price NUMERIC,
    freight_value NUMERIC
);

CREATE TABLE IF NOT EXISTS order_payments (
    order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value NUMERIC
);

CREATE TABLE IF NOT EXISTS order_reviews (
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255),
    order_status VARCHAR(50),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(255) PRIMARY KEY,
    product_category_name VARCHAR(255),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

CREATE TABLE IF NOT EXISTS sellers (
    seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(50),
    seller_city VARCHAR(255),
    seller_state VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255)
);

COPY customers FROM '/data/seed/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;
COPY geolocation FROM '/data/seed/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;
COPY order_items FROM '/data/seed/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;
COPY order_payments FROM '/data/seed/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;
COPY order_reviews FROM '/data/seed/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM '/data/seed/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;
COPY products FROM '/data/seed/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;
COPY sellers FROM '/data/seed/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;
COPY product_category_name_translation FROM '/data/seed/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;
