-- CHALLENGE 4: Subqueries & CTEs
-- 
-- 4.1 Tampilkan `order_id` dan `payment_value` dari tabel `order_payments` yang nilai pembayarannya (`payment_value`) lebih besar dari rata-rata seluruh pembayaran. (Gunakan Subquery)
-- Tulis query Anda di bawah ini:
SELECT order_id, payment_value
FROM order_payments
WHERE payment_value > (SELECT AVG(payment_value) FROM order_payments);


-- 4.2 Gunakan CTE (Common Table Expression) untuk menghitung total 
-- pengeluaran (jumlah `payment_value`) per `customer_id`. Tampilkan 3 `customer_id` dengan total pengeluaran tertinggi beserta nilai `total_spent`-nya.
-- Tulis query Anda di bawah ini:
WITH customer_spending AS(
    SELECT o.customer_id, SUM(op.payment_value) as total_spent 
    FROM orders as o
    JOIN order_payments as op 
        ON o.order_id = op.order_id
    GROUP BY o.customer_id
)
SELECT customer_id, total_spent
FROM customer_spending
ORDER BY total_spent DESC LIMIT 3;

-- 4.3 Tampilkan `product_id` dan `product_category_name` dari tabel `products` untuk produk yang tidak pernah dipesan sama sekali (tidak ada di tabel `order_items`). (Gunakan Subquery)
-- Tulis query Anda di bawah ini:
SELECT
    product_id,
    product_category_name
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM order_items
);

-- 4.4 Dengan menggunakan CTE, cari penjual (`seller_id` pada tabel `order_items`) yang memiliki jumlah pesanan (unik `order_id`) lebih dari 1000. Tampilkan `seller_id` dan `total_orders`.
-- Tulis query Anda di bawah ini:
WITH seller_orders AS (
    SELECT seller_id, COUNT(DISTINCT order_id) as total_orders
    FROM order_items
    GROUP BY seller_id
)
SELECT seller_id, total_orders
FROM seller_orders
WHERE total_orders > 1000;