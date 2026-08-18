/*
=============================================================================
CHALLENGE 7: DATA CLEANING & STRING MANIPULATIONS
=============================================================================
Dalam praktiknya, data mentah sering kali kotor atau formatnya tidak konsisten.
Tahap ini akan menguji kemampuan Anda dalam membersihkan teks, menangani 
data kosong (NULL), dan memanipulasi tipe data string di PostgreSQL.
*/

-- 7.1 Membersihkan Nama Kategori Produk
-- Pada tabel `products`, kolom `product_category_name` memiliki format yang menggunakan 
-- underscore/garis bawah (contoh: `cama_mesa_banho`, `esporte_lazer`).
-- Tugas Anda:
-- Tampilkan `product_id`, `product_category_name` (asli), dan buat kolom baru `clean_category_name`.
-- `clean_category_name` harus mengganti garis bawah (_) dengan spasi ( ),
-- dan setiap awal kata harus berhuruf kapital (Title Case).
-- Contoh hasil yang diharapkan: `cama_mesa_banho` menjadi `Cama Mesa Banho`.
-- Hint: Gunakan fungsi REPLACE() dan INITCAP().

-- Tulis query Anda di bawah ini:
SELECT product_id,
    product_category_name,
    INITCAP(REPLACE(product_category_name, '_', ' ')) AS clean_category_name
FROM products LIMIT 10;


-- 7.2 Menstandarisasi Nama Kota Pelanggan
-- Terkadang, data teks memiliki spasi tambahan di awal/akhir kata yang bisa merusak analisis.
-- Dari tabel `customers`, tampilkan `customer_id` dan `customer_city`.
-- Buat kolom baru `standardized_city` yang memastikan tidak ada spasi berlebih di awal/akhir
-- nama kota dan pastikan seluruh hurufnya dikonversi menjadi huruf kapital.
-- Hint: Gunakan UPPER() dan TRIM().

-- Tulis query Anda di bawah ini:
SELECT customer_id,
    customer_city,
    UPPER(TRIM(customer_city)) AS standardized_city
FROM customers LIMIT 10;


-- 7.3 Menangani Nilai NULL (Pesanan yang Belum Terkirim)
-- Pada tabel `orders`, jika pesanan belum sampai atau dibatalkan, maka `order_delivered_customer_date` 
-- akan bernilai NULL.
-- Kita ingin menampilkan status pengiriman, namun jika datanya NULL, berikan label "Not Delivered Yet".
-- Tampilkan `order_id`, `order_status`, `order_estimated_delivery_date`, 
-- dan kolom baru `actual_delivery_status`.
-- Kolom `actual_delivery_status` berisi tanggal pengiriman (format 'YYYY-MM-DD') jika sudah terkirim, 
-- atau teks "Not Delivered Yet" jika bernilai NULL.
-- Hint: Anda bisa menggunakan COALESCE() atau ekspresi CASE WHEN.
-- Ingat: Anda perlu melakukan casting tipe data dari TIMESTAMP/DATE menjadi VARCHAR/TEXT
-- agar bisa disatukan dengan string "Not Delivered Yet".

-- Tulis query Anda di bawah ini:
SELECT order_id,
    order_status,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    COALESCE(TO_CHAR(order_delivered_customer_date, 'YYYY-MM-DD'), 'Not Delivered Yet') AS actual_delivery_status
FROM orders LIMIT 10;
