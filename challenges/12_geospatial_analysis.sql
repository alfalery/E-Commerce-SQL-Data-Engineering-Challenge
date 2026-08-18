/*
=============================================================================
CHALLENGE 12: GEOSPATIAL DISTANCE ANALYSIS
=============================================================================
Olist adalah platform e-commerce yang melayani seluruh penjuru Brazil. 
Biaya ongkos kirim (freight_value) dan waktu pengiriman sangat bergantung 
pada jarak antara penjual (seller) dan pembeli (customer).

Dataset ini dilengkapi dengan tabel `geolocation` yang menyimpan data 
latitude dan longitude berdasarkan kode pos (zip code prefix).
*/

-- 12.1 Menghitung Jarak antara Penjual dan Pembeli
-- Untuk menyederhanakan, kita akan menggunakan pendekatan Euclidean Distance 
-- (jarak garis lurus sederhana pada bidang datar) dari koordinat Latitude dan Longitude.
-- 
-- Rumus sederhana Euclidean Distance: 
-- SQRT(POWER(lat1 - lat2, 2) + POWER(lng1 - lng2, 2))
-- (Note: Ini bukan jarak aktual dalam kilometer, namun angka rasio kedekatan).
--
-- Tugas Anda:
-- 1. Dapatkan latitude & longitude pembeli (customer) dengan melakukan JOIN ke tabel `geolocation`.
-- 2. Dapatkan latitude & longitude penjual (seller) dengan melakukan JOIN ke tabel `geolocation`.
--    (Hint: Hati-hati, satu kode pos di tabel `geolocation` bisa memiliki beberapa baris koordinat. 
--           Gunakan GROUP BY zip_code dan ambil rata-rata AVG(lat) dan AVG(lng) terlebih dahulu dalam sebuah CTE).
-- 3. Tampilkan: `order_id`, `customer_city`, `seller_city`, dan hitung `distance_score` 
--    menggunakan rumus Euclidean di atas.
-- Batasi hasil hanya 10 baris pertama.

-- Tulis query Anda di bawah ini:
WITH geo_avg AS (
    -- 1. Menghitung rata-rata koordinat per zip_code_prefix untuk menghindari duplikasi
    SELECT 
        geolocation_zip_code_prefix,
        AVG(geolocation_lat) AS avg_lat,
        AVG(geolocation_lng) AS avg_lng
    FROM 
        geolocation
    GROUP BY 
        geolocation_zip_code_prefix
)
SELECT 
    o.order_id,
    c.customer_city,
    s.seller_city,
    -- 3. Menghitung Euclidean Distance antara Customer dan Seller
    SQRT(
        POWER(c_geo.avg_lat - s_geo.avg_lat, 2) + 
        POWER(c_geo.avg_lng - s_geo.avg_lng, 2)
    ) AS distance_score
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    sellers s ON oi.seller_id = s.seller_id
-- 2. Join koordinat customer & seller dari CTE
JOIN 
    geo_avg c_geo ON c.customer_zip_code_prefix = c_geo.geolocation_zip_code_prefix
JOIN 
    geo_avg s_geo ON s.seller_zip_code_prefix = s_geo.geolocation_zip_code_prefix
LIMIT 10;