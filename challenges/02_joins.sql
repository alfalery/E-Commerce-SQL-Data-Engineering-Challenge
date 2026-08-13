-- CHALLENGE 2: Joins
--
-- 2.1 Tampilkan `order_id`, `customer_id`, dan `customer_city` dengan melakukan JOIN 
-- antara tabel `orders` dan `customers`.
-- Tulis query Anda di bawah ini:
SELECT order_id, orders.customer_id, customer_city 
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id;


-- 2.2 Tampilkan daftar `order_id` beserta nama kategori produknya dalam bahasa Inggris.
-- Hint: Anda perlu melakukan JOIN antara `order_items`, `products`, dan `product_category_name_translation`.
-- Tulis query Anda di bawah ini:
SELECT order_id, product_category_name_english FROM order_items
JOIN products on order_items.product_id = products.product_id
JOIN product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name;

-- 2.3 Tampilkan `seller_id`, `seller_city`, dan jumlah total revenue (harga * jumlah) yang didapat oleh setiap seller.
-- Hint: JOIN antara `sellers` dan `order_items`. Group by seller_id.
-- Tulis query Anda di bawah ini:
SELECT
    sellers.seller_id,
    sellers.seller_city,
    SUM(order_items.price * order_items.freight_value) AS revenue
FROM sellers
JOIN order_items
    ON sellers.seller_id = order_items.seller_id
GROUP BY
    sellers.seller_id,
    sellers.seller_city;