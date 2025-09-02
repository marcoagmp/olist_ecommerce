CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;

-- Tabela de Geolocation
-- Esta tabela é uma referência de códigos postais e suas coordenadas.
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(10, 8),
    geolocation_city VARCHAR(50),
    geolocation_state CHAR(2),
    PRIMARY KEY (geolocation_zip_code_prefix, geolocation_lat,
    geolocation_lng)
);

-- Tabela de Clientes
-- Armazena informações dos clientes, conectada aos pedidos.
CREATE TABLE customers (
    customer_id VARCHAR(32) NOT NULL,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(50),
    customer_state CHAR(2),
    PRIMARY KEY (customer_id),
    FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation(geolocation_zip_code_prefix)
);

-- Tabela de Vendedores
-- Armazena informações dos vendedores, conectada aos itens do pedido.
CREATE TABLE sellers (
    seller_id VARCHAR(32) NOT NULL,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(50),
    seller_state CHAR(2),
    PRIMARY KEY (seller_id),
    FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation(geolocation_zip_code_prefix)
);

-- Tabela de Produtos
-- Armazena informações dos produtos disponíveis para venda.
CREATE TABLE products (
    product_id VARCHAR(32) NOT NULL,
    product_category_name VARCHAR(50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    PRIMARY KEY (product_id)
);

-- Tabela de Pedidos
-- Tabela principal, que contém o status de cada pedido e as chaves para outras tabelas.
CREATE TABLE orders (
    order_id VARCHAR(32) NOT NULL,
    customer_id VARCHAR(32),
    order_status VARCHAR(15),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tabela de Pagamentos do Pedido
-- Armazena os detalhes de pagamento de cada pedido.
CREATE TABLE order_payments (
    order_id VARCHAR(32) NOT NULL,
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Tabela de Avaliações do Pedido
-- Armazena as avaliações dadas pelos clientes para cada pedido.
CREATE TABLE order_reviews (
    review_id VARCHAR(32) NOT NULL,
    order_id VARCHAR(32),
    review_score INT,
    review_comment_title VARCHAR(50),
    review_comment_message VARCHAR(250),
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    PRIMARY KEY (review_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Tabela de Itens do Pedido
-- Tabela de junção que conecta Pedidos, Produtos e Vendedores.
CREATE TABLE order_items (
    order_id VARCHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

