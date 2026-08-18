/*
=============================================================================
CHALLENGE 6: ADVANCED ANALYTICS & COHORT ANALYSIS
=============================================================================
Di tahap ini, kita akan fokus pada kasus bisnis dunia nyata seperti analisis 
runtut waktu (time-series), metrik pertumbuhan (growth), dan retensi pelanggan.
*/

-- 6.1 Month-over-Month (MoM) Revenue Growth
-- Temukan total pendapatan (gunakan `price` dari tabel `order_items` digabung dengan `orders`) per bulan.
-- Kemudian, hitung persentase pertumbuhan (growth) pendapatan dari bulan sebelumnya.
-- Tampilkan: `order_month` (format YYYY-MM), `current_revenue`, `previous_revenue`, 
-- dan `mom_growth_percentage`.
-- Hint: Gunakan DATE_TRUNC() atau TO_CHAR(), CTE (Common Table Expression), dan fungsi `LAG()`.

-- Tulis query Anda di bawah ini:
WITH revenue_per_month AS (
    SELECT TO_CHAR(DATE_TRUNC('month', o.order_purchase_timestamp),'yyyy-MM') AS order_month,
    SUM(price) as current_revenue
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY order_month
    
),

previous_revenue AS (
    SELECT order_month,
    current_revenue,
    LAG(current_revenue) OVER (ORDER BY order_month) as previous_revenue
    FROM revenue_per_month
)
SELECT * FROM previous_revenue;

-- 6.2 7-Day Moving Average of Daily Revenue
-- Hitung total pendapatan harian (gunakan `order_purchase_timestamp` dari tabel `orders` 
-- dan `price` dari `order_items`). 
-- Buat kolom baru yang menampilkan "7-day moving average" (rata-rata pendapatan 
-- selama 7 hari terakhir termasuk hari tersebut).
-- Tampilkan: `order_date`, `daily_revenue`, dan `moving_avg_7d`.
-- Hint: Gunakan Window Function `AVG() OVER(...)` dengan frame `ROWS BETWEEN 6 PRECEDING AND CURRENT ROW`.

-- Tulis query Anda di bawah ini:
WITH revenue_per_day AS (
    SELECT
        DATE(o.order_purchase_timestamp) AS order_date,
        SUM(oi.price) AS daily_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE(o.order_purchase_timestamp)
)

SELECT
    order_date,
    daily_revenue,
    AVG(daily_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7d
FROM revenue_per_day
ORDER BY order_date;



-- 6.3 Customer Retention (Time Between First and Second Order)
-- Pada e-commerce, seringkali kita ingin tahu seberapa cepat seorang customer melakukan 
-- pembelian kedua (repeat order).
-- Temukan `customer_unique_id` (dari tabel `customers`), `first_order_date`, dan `second_order_date`.
-- Serta hitung selisih hari (`days_between_orders`) antara order pertama dan kedua.
-- Filter HANYA customer yang pernah berbelanja lebih dari 1 kali.
-- Hint: Gunakan `ROW_NUMBER()` untuk melabeli urutan order setiap customer, lalu lakukan SELF JOIN atau CTE Pivot.

-- Tulis query Anda di bawah ini:
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS order_sequence
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
),

first_second_orders AS (
    SELECT
        customer_unique_id,
        MAX(
            CASE
                WHEN order_sequence = 1
                THEN order_purchase_timestamp
            END
        ) AS first_order_date,
        MAX(
            CASE
                WHEN order_sequence = 2
                THEN order_purchase_timestamp
            END
        ) AS second_order_date
    FROM customer_orders
    GROUP BY customer_unique_id
    HAVING COUNT(*) >= 2
)

SELECT
    customer_unique_id,
    first_order_date,
    second_order_date,
    second_order_date::date - first_order_date::date AS days_between_orders
FROM first_second_orders
ORDER BY customer_unique_id;

