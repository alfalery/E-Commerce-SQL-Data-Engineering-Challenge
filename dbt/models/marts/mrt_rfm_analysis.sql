{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),
max_date_cte AS (
    -- Mendapatkan tanggal pembelian paling akhir di seluruh tabel orders (berstatus delivered)
    SELECT MAX(order_purchase_timestamp) AS max_purchase_date
    FROM orders
    WHERE order_status = 'delivered'
),
order_monetary AS (
    -- Menghitung total monetary per order dari order_items (price + freight_value)
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
