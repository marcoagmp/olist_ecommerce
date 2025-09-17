CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;

-- Tabela de Geolocation
-- Esta tabela é uma referência de códigos postais e suas coordenadas.		

CREATE TABLE `geolocation` (
  `geolocation_zip_code_prefix` int NOT NULL,
  `geolocation_lat` float DEFAULT NULL,
  `geolocation_lng` float DEFAULT NULL,
  `geolocation_city` varchar(50) DEFAULT NULL,
  `geolocation_state` char(2) DEFAULT NULL
);

-- Tabela de Clientes
-- Armazena informações dos clientes, conectada aos pedidos.

CREATE TABLE `customers` (
  `customer_id` varchar(32) NOT NULL,
  `customer_unique_id` varchar(32) NOT NULL,
  `customer_zip_code_prefix` int DEFAULT NULL,
  `customer_city` varchar(50) DEFAULT NULL,
  `customer_state` char(2) DEFAULT NULL,
  UNIQUE KEY `customer_id` (`customer_id`)
);


-- Tabela de Vendedores
-- Armazena informações dos vendedores, conectada aos itens do pedido.

CREATE TABLE `sellers` (
  `seller_id` varchar(32) NOT NULL,
  `seller_zip_code_prefix` int DEFAULT NULL,
  `seller_city` varchar(50) DEFAULT NULL,
  `seller_state` char(2) DEFAULT NULL,
  PRIMARY KEY (`seller_id`)
);

-- Tabela de Produtos
-- Armazena informações dos produtos disponíveis para venda.

CREATE TABLE `products` (
  `product_id` varchar(32) NOT NULL,
  `product_category_name` varchar(50) DEFAULT NULL,
  `product_name_lenght` int DEFAULT NULL,
  `product_description_lenght` int DEFAULT NULL,
  `product_photos_qty` int DEFAULT NULL,
  `product_weight_g` int DEFAULT NULL,
  `product_length_cm` int DEFAULT NULL,
  `product_height_cm` int DEFAULT NULL,
  `product_width_cm` int DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  ADD CONSTRAINT `product_category_translation` FOREIGN KEY(`product_category_name`) REFERENCES `products_category_name_translation` (`product_category_name`)
);

-- Tabela de Pedidos
-- Tabela principal, que contém o status de cada pedido e as chaves para outras tabelas.

CREATE TABLE `orders` (
  `order_id` varchar(32) NOT NULL,
  `customer_id` varchar(32) DEFAULT NULL,
  `order_status` varchar(15) DEFAULT NULL,
  `order_purchase_timestamp` datetime DEFAULT NULL,
  `order_approved_at` datetime DEFAULT NULL,
  `order_delivered_carrier_date` datetime DEFAULT NULL,
  `order_delivered_customer_date` datetime DEFAULT NULL,
  `order_estimated_delivery_date` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  ADD CONSTRAINT `fk_orders_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`)
);

-- Tabela de Pagamentos do Pedido
-- Armazena os detalhes de pagamento de cada pedido.

CREATE TABLE `order_payments` (
  `order_id` varchar(32) NOT NULL,
  `payment_sequential` int NOT NULL,
  `payment_type` varchar(20) DEFAULT NULL,
  `payment_installments` int DEFAULT NULL,
  `payment_value` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`order_id`,`payment_sequential`),
  ADD CONSTRAINT `order_payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
);

-- Tabela de Avaliações do Pedido
-- Armazena as avaliações dadas pelos clientes para cada pedido.
CREATE TABLE `order_reviews` (
  `review_id` varchar(32) NOT NULL,
  `order_id` varchar(32) DEFAULT NULL,
  `review_score` int DEFAULT NULL,
  `review_comment_title` varchar(50) DEFAULT NULL,
  `review_comment_message` varchar(250) DEFAULT NULL,
  `review_creation_date` datetime DEFAULT NULL,
  `review_answer_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  ADD CONSTRAINT `order_reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
);

-- Tabela de Itens do Pedido
-- Tabela de junção que conecta Pedidos, Produtos e Vendedores.
CREATE TABLE `order_items` (
  `order_id` varchar(32) NOT NULL,
  `order_item_id` int NOT NULL,
  `product_id` varchar(32) DEFAULT NULL,
  `seller_id` varchar(32) DEFAULT NULL,
  `shipping_limit_date` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `freight_value` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`order_id`,`order_item_id`),
  KEY `product_id` (`product_id`),
  KEY `seller_id` (`seller_id`),
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`seller_id`) REFERENCES `sellers` (`seller_id`)
);
CREATE TABLE `products_category_name_translation` (
  `product_category_name` varchar(50) NOT NULL,
  `product_category_name_english` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_category_name`)
);

ALTER TABLE products ADD CONSTRAINT product_category_translation FOREIGN KEY (product_category_name) REFERENCES		  		products_category_name_translation(product_category_name);

