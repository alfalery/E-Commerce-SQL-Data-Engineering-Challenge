/*
=============================================================================
CHALLENGE 11: E-COMMERCE RFM ANALYSIS (BUSINESS CASE STUDY)
=============================================================================
Dalam dunia E-Commerce yang nyata, mengetahui siapa pelanggan terbaik Anda
adalah hal yang sangat krusial. RFM (Recency, Frequency, Monetary) Analysis
adalah salah satu metode paling populer yang digunakan oleh Data Analyst
dan Data Engineer untuk melakukan segmentasi pelanggan.

- RECENCY (R): Seberapa baru pelanggan melakukan pembelian? (Semakin kecil selisih harinya, semakin baik)
- FREQUENCY (F): Seberapa sering mereka membeli? (Semakin tinggi, semakin baik)
- MONETARY (M): Seberapa banyak uang yang mereka habiskan? (Semakin tinggi, semakin baik)

Sebagai Data Engineer, Anda ditugaskan untuk menyiapkan data mentahnya dalam format RFM.
*/

-- 11.1 Menghitung Metric RFM Dasar
-- Tugas Anda:
-- Tampilkan `customer_id` beserta 3 metrik RFM untuk setiap pelanggan:
-- 1. `recency`: Selisih hari antara tanggal pembelian terakhir si pelanggan dengan 
--    tanggal pembelian terbaru di seluruh tabel `orders`.
--    (Hint: Gunakan MAX(order_purchase_timestamp) dan bandingkan dengan MAX() dari setiap pelanggan)
-- 2. `frequency`: Jumlah total pesanan (order_id) yang pernah dilakukan oleh pelanggan tersebut.
-- 3. `monetary`: Total uang yang dihabiskan oleh pelanggan tersebut (termasuk harga produk + ongkos kirim).
--    (Hint: Anda perlu melakukan JOIN ke tabel `order_payments` atau `order_items`)
-- 
-- Batasi hasil hanya untuk pelanggan yang pesanannya berstatus 'delivered'.
-- Tampilkan 10 baris pertama.

-- Tulis query Anda di bawah ini:
WITH max_date_cte AS (
    -- Mendapatkan tanggal pembelian paling akhir di seluruh tabel orders (berstatus delivered)
    SELECT MAX(order_purchase_timestamp) AS max_purchase_date
    FROM orders
    WHERE order_status = 'delivered'
),
order_monetary AS (
    -- Menghitung total monetary per order dari order_items (price + freight_value)
    -- Menggunakan order_items per order untuk menghindari duplikasi nilai jika di-join langsung
    SELECT 
        order_id,
        SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
)
SELECT 
    o.customer_id,
    -- 1. Recency: Selisih hari antara transaksi terakhir global dengan transaksi terakhir customer
    (m.max_purchase_date::DATE - MAX(o.order_purchase_timestamp)::DATE) AS recency,
    -- 2. Frequency: Total pesanan unik per customer
    COUNT(DISTINCT o.order_id) AS frequency,
    -- 3. Monetary: Akumulasi total belanja produk + ongkir
    COALESCE(SUM(om.order_total), 0) AS monetary
FROM 
    orders o
JOIN 
    order_monetary om ON o.order_id = om.order_id
CROSS JOIN 
    max_date_cte m
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    o.customer_id, 
    m.max_purchase_date
ORDER BY 
    recency ASC, 
    monetary DESC
LIMIT 10;