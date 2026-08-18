-- CHALLENGE 5: Window Functions
--
-- 5.1 Gunakan `ROW_NUMBER()` untuk memberikan nomor urut pesanan (order) bagi setiap pelanggan (`customer_id`). 
-- Urutkan berdasarkan waktu pembelian (`order_purchase_timestamp`) dari yang paling lama ke yang paling baru.
-- Tampilkan `customer_id`, `order_id`, `order_purchase_timestamp`, dan kolom baru bernama `order_sequence`.
-- Tulis query Anda di bawah ini:
WITH rank_orders AS (
    SELECT customer_id, 
    order_id, 
    order_purchase_timestamp,
    ROW_NUMBER() OVER (PARTITION BY customer_id 
    ORDER BY order_purchase_timestamp ASC) as order_sequence
    FROM orders
)
SELECT * FROM rank_orders;


-- 5.2 Gunakan `RANK()` atau `DENSE_RANK()` untuk memberikan peringkat pada penjual (`seller_id`) berdasarkan total pendapatan (jumlah `price` dari tabel `order_items`) dari yang tertinggi ke terendah.
-- Tampilkan `seller_id`, total pendapatan (`total_revenue`), dan peringkatnya (`revenue_rank`).
-- (Petunjuk: Anda bisa menggunakan CTE/Subquery terlebih dahulu untuk menghitung total pendapatan per seller, baru kemudian menggunakan Window Function).
-- Tulis query Anda di bawah ini:
WITH seller_revenue AS (
    SELECT seller_id,
    SUM(price) as total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT seller_id, 
        total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank
FROM seller_revenue;

-- 5.3 Gunakan Window Function `SUM() OVER(PARTITION BY ...)` untuk melihat harga suatu produk dan total harga seluruh produk di dalam pesanan yang sama (`order_id`).
-- Tampilkan `order_id`, `product_id`, `price`, dan kolom baru `total_order_price` (jumlah `price` dari semua produk pada `order_id` yang sama).
-- Anda cukup menggunakan tabel `order_items`.
-- Tulis query Anda di bawah ini:
WITH order_total AS (
    SELECT order_id, product_id, price, SUM(price)
    OVER (PARTITION BY order_id) as total_order_price
    FROM order_items
)
SELECT * FROM order_total ;