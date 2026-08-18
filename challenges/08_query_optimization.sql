/*
=============================================================================
CHALLENGE 8: QUERY OPTIMIZATION & PERFORMANCE TUNING
=============================================================================
Seiring bertambah besarnya ukuran data, performa query menjadi sangat penting.
Tahap ini akan menguji kemampuan Anda dalam menganalisis rencana eksekusi (execution plan)
dan mengoptimalkan query menggunakan indeks di PostgreSQL.
*/

-- 8.1 Menganalisis Performa Query dengan EXPLAIN ANALYZE
-- Sebelum melakukan optimasi, kita perlu mengukur seberapa lambat query kita.
-- Gunakan EXPLAIN ANALYZE untuk melihat execution plan dari query berikut,
-- yang mencari pesanan dari pelanggan di kota 'sao paulo'.
-- Tugas Anda:
-- Jalankan query di bawah ini dengan menambahkan perintah EXPLAIN ANALYZE di awalnya.
-- Amati 'Execution Time' dan strategi scan ('Seq Scan') pada output.

-- Tulis query Anda di bawah ini:
EXPLAIN ANALYZE
SELECT o.order_id, c.customer_id, c.customer_city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_city = 'sao paulo';



-- 8.2 Membuat Indeks untuk Meningkatkan Performa
-- Berdasarkan query pada 8.1, pencarian berdasarkan kota pelanggan (customer_city)
-- mungkin memakan waktu karena sistem harus melakukan Sequential Scan pada tabel customers.
-- Tugas Anda:
-- Buatlah sebuah B-Tree index pada kolom `customer_city` di tabel `customers` 
-- dengan nama `idx_customers_city`.
-- Hint: Gunakan sintaks CREATE INDEX ... ON ... (...);

-- Tulis query Anda di bawah ini:
CREATE INDEX idx_customers_city ON customers (customer_city);


-- 8.3 Memverifikasi Peningkatan Performa
-- Setelah indeks dibuat, mari kita periksa apakah ada peningkatan performa.
-- Tugas Anda:
-- Jalankan kembali query pada 8.1 menggunakan EXPLAIN ANALYZE.
-- Bandingkan 'Execution Time' dan pastikan bahwa PostgreSQL sekarang menggunakan 
-- Index Scan atau Bitmap Index Scan alih-alih Sequential Scan.

-- Tulis query Anda di bawah ini:
EXPLAIN ANALYZE
SELECT o.order_id, c.customer_id, c.customer_city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_city = 'sao paulo';
