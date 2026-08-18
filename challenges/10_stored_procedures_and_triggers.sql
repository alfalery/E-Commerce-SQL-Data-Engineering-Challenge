/*
=============================================================================
CHALLENGE 10: STORED PROCEDURES & TRIGGERS
=============================================================================
Sebagai Data Engineer, Anda kadang diminta untuk mengotomatisasi beberapa logika 
di level database. Stored Procedures dan Triggers memungkinkan Anda untuk 
menyimpan fungsi komputasi langsung di dalam PostgreSQL.
Ini adalah tantangan terakhir yang akan memantapkan pemahaman Anda di level lanjut!
*/

-- 10.1 Membuat Fungsi (Stored Function)
-- Mari kita buat sebuah fungsi sederhana untuk menghitung selisih hari antara
-- `order_estimated_delivery_date` dan `order_delivered_customer_date`.
-- Fungsi ini akan membantu analisis pengiriman tepat waktu (on-time delivery).
-- Tugas Anda:
-- Buat fungsi bernama `calculate_delivery_delay` yang menerima 2 parameter bertipe TIMESTAMP,
-- dan mengembalikan nilai INTEGER (selisih dalam hitungan hari).
-- Hint: Gunakan sintaks CREATE OR REPLACE FUNCTION ... RETURNS INTEGER AS $$ ...

-- Tulis query Anda di bawah ini:
CREATE OR REPLACE FUNCTION calculate_delivery_delay(
    p_order_estimated_delivery_date TIMESTAMP,
    p_order_delivered_customer_date TIMESTAMP
)
RETURNS INTEGER AS $$
DECLARE
    delay_days INTEGER;
BEGIN
    -- Handle NULL case: if delivered date is null, return NULL
    IF p_order_delivered_customer_date IS NULL THEN
        RETURN NULL;
    END IF;
    
    -- Calculate the difference in days
    -- PostgreSQL allows direct subtraction of timestamps resulting in an interval
    -- We cast the interval to integer days
    delay_days := (p_order_delivered_customer_date - p_order_estimated_delivery_date);
    
    RETURN delay_days;
END;
$$ LANGUAGE plpgsql;
    


-- 10.2 Menggunakan Fungsi yang Dibuat
-- Setelah fungsi selesai dibuat, mari kita gunakan pada tabel `orders`.
-- Tugas Anda:
-- Tampilkan `order_id` dan hasil dari fungsi `calculate_delivery_delay` 
-- berikan alias `delay_days`.
-- Batasi output hanya 10 baris pertama di mana status pesanan adalah 'delivered'.

-- Tulis query Anda di bawah ini:
SELECT 
    order_id,
    calculate_delivery_delay(order_estimated_delivery_date, order_delivered_customer_date) AS delay_days
FROM 
    orders
WHERE 
    order_status = 'delivered'
LIMIT 10;


-- 10.3 Membuat Trigger untuk Audit (Opsional/Tingkat Lanjut)
-- Perusahaan ingin mencatat setiap kali status pesanan (order_status) berubah di tabel orders.
-- Tugas Anda:
-- 1. Buat tabel `order_status_audit` dengan kolom: audit_id (SERIAL PRIMARY KEY), order_id (VARCHAR), old_status (VARCHAR), new_status (VARCHAR), changed_at (TIMESTAMP DEFAULT CURRENT_TIMESTAMP).
-- 2. Buat fungsi trigger bernama `log_status_change()` yang memasukkan data ke tabel audit.
-- 3. Buat TRIGGER `trg_order_status_change` pada tabel `orders` yang memanggil fungsi tersebut AFTER UPDATE.

-- Tulis query Anda di bawah ini:
-- 1. Buat tabel audit untuk mencatat perubahan status pesanan
CREATE TABLE order_status_audit (
    audit_id SERIAL PRIMARY KEY,
    order_id VARCHAR,
    old_status VARCHAR,
    new_status VARCHAR,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Buat fungsi trigger untuk mencatat data ke tabel audit
CREATE OR REPLACE FUNCTION log_status_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Hanya catat jika terjadi perubahan nilai pada kolom order_status
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN
        INSERT INTO order_status_audit (order_id, old_status, new_status, changed_at)
        VALUES (OLD.order_id, OLD.order_status, NEW.order_status, CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Pasang TRIGGER pada tabel orders yang berjalan AFTER UPDATE
CREATE TRIGGER trg_order_status_change
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION log_status_change();