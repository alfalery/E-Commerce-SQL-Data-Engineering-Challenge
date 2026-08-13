-- CHALLENGE 3: Aggregations & Group By
--
-- 3.1 Hitung jumlah pesanan (orders) per status (`order_status`).
-- Tulis query Anda di bawah ini:
SELECT order_status, COUNT(order_id) as total_orders
FROM orders
GROUP BY order_status;

-- 3.2 Tampilkan 5 kota asal customer dengan jumlah pesanan terbanyak.
-- Tulis query Anda di bawah ini:
SELECT customer_city, COUNT(customer_id) as total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 5;

-- 3.3 Hitung rata-rata nilai pembayaran (`payment_value`) per tipe pembayaran (`payment_type`).
-- Tulis query Anda di bawah ini:
SELECT payment_type, AVG(payment_value) as average_payment
FROM order_payments
GROUP BY payment_type;

-- 3.4 Cari kategori produk (dalam bahasa Inggris) yang memiliki rata-rata skor ulasan (review_score) tertinggi.
-- Tulis query Anda di bawah ini:
SELECT
    pct.product_category_name_english,
    AVG(orev.review_score) AS average_review_score
FROM product_category_name_translation AS pct
JOIN products AS p
    ON p.product_category_name = pct.product_category_name
JOIN order_items AS oi
    ON oi.product_id = p.product_id
JOIN order_reviews AS orev
    ON orev.order_id = oi.order_id
GROUP BY
    pct.product_category_name_english
ORDER BY
    average_review_score DESC;