/*
=============================================================================
CHALLENGE 9: VIEWS & MATERIALIZED VIEWS
=============================================================================
Dalam dunia Data Engineering, kita sering kali harus menyajikan data agregasi
atau hasil join yang rumit kepada analis atau dashboard. Membuat View (atau
Materialized View) adalah cara standar untuk menyederhanakan akses ke data 
tersebut tanpa mengekspos kompleksitas kueri di baliknya.
*/

-- 9.1 Membuat View Sederhana
-- Bayangkan analis data sering membutuhkan informasi pesanan beserta status
-- dan nama pelanggan. Daripada mereka melakukan JOIN berulang kali, buatlah
-- sebuah View bernama `v_customer_orders`.
-- View ini harus menampilkan: `order_id`, `order_status`, `customer_id`, 
-- dan `customer_city` dari gabungan tabel `orders` dan `customers`.
-- Tugas Anda:
-- Tulis statement CREATE VIEW untuk `v_customer_orders`.

-- Tulis query Anda di bawah ini:
CREATE VIEW v_customer_orders AS
SELECT 
    o.order_id,
    o.order_status,
    c.customer_id,
    c.customer_city
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id;


-- 9.2 Menggunakan View yang Dibuat
-- Sekarang setelah View dibuat, analis bisa memanggilnya layaknya tabel biasa.
-- Tugas Anda:
-- Lakukan SELECT semua kolom dari `v_customer_orders` namun batasi hanya
-- untuk pesanan yang berstatus 'delivered' dan berada di kota 'rio de janeiro'.
-- Batasi output menjadi 10 baris pertama.

-- Tulis query Anda di bawah ini:
SELECT * FROM v_customer_orders
WHERE order_status = 'delivered'
AND customer_city = 'rio de janeiro';




-- 9.3 Membuat Materialized View untuk Analisis Berat
-- View biasa akan mengeksekusi ulang query setiap kali dipanggil.
-- Untuk query yang sangat berat (seperti agregasi data dari jutaan baris),
-- Materialized View lebih disarankan karena menyimpan hasil secara fisik.
-- Tugas Anda:
-- Buatlah Materialized View bernama `mv_seller_revenue`.
-- Materialized view ini harus menghitung total pendapatan (sum dari `price` di `order_items`) 
-- per `seller_id`.
-- Tampilkan: `seller_id` dan `total_revenue`.
-- Hint: Gunakan CREATE MATERIALIZED VIEW ... AS ...

-- Tulis query Anda di bawah ini:
CREATE MATERIALIZED VIEW mv_seller_revenue AS
SELECT 
    seller_id,
    SUM(price) AS total_revenue
FROM 
    order_items
GROUP BY 
    seller_id;



-- 9.4 Refresh Materialized View
-- Salah satu karakteristik Materialized View adalah datanya bisa kedaluwarsa.
-- Bagaimana cara Anda memperbarui data di dalam `mv_seller_revenue` jika
-- ada transaksi baru yang masuk?
-- Tugas Anda:
-- Tulis perintah untuk melakukan refresh pada `mv_seller_revenue`.

-- Tulis query Anda di bawah ini:
REFRESH MATERIALIZED VIEW mv_seller_revenue;
