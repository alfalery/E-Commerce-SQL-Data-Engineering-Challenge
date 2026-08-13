-- CHALLENGE 1: Basic SELECT and Filtering
-- 
-- 1.1 Tampilkan semua data dari tabel `customers`.
-- Tulis query Anda di bawah ini:
SELECT * FROM customers;


-- 1.2 Tampilkan `customer_id` dan `customer_city` untuk customer yang berada di kota 'sao paulo'.
-- Tulis query Anda di bawah ini:
SELECT customer_id, customer_city FROM customers WHERE customer_city = 'sao paulo';

-- 1.3 Tampilkan 10 transaksi (orders) terbaru berdasarkan `order_purchase_timestamp`.
-- Tulis query Anda di bawah ini:
SELECT * FROM orders ORDER BY order_purchase_timestamp DESC LIMIT 10;

-- 1.4 Cari total seluruh produk (products) yang memiliki kategori 'beleza_saude'.
-- Tulis query Anda di bawah ini:
SELECT SUM(product_photos_qty) AS total_products
FROM products WHERE product_category_name = 'beleza_saude';