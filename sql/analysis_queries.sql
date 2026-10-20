-- 1. Jumlah baris detail jika tabel detail diaktifkan.
SELECT COUNT(*) AS total_rows
FROM retail_analytics.sales_transactions_enriched;

-- 2. Tren penjualan bulanan.
SELECT month, receipts, units_sold, sales_value, gross_profit
FROM retail_analytics.monthly_sales
ORDER BY month;

-- 3. Lima toko dengan nilai penjualan terbesar.
SELECT store_id, store_name, store_city, sales_value, gross_profit
FROM retail_analytics.store_sales
ORDER BY sales_value DESC
LIMIT 5;

-- 4. Kategori dengan kontribusi terbesar.
SELECT category,
       SUM(sales_value) AS sales_value,
       SUM(gross_profit) AS gross_profit
FROM retail_analytics.category_sales
GROUP BY category
ORDER BY sales_value DESC;

-- 5. Performa kanal penjualan.
SELECT channel, receipts, units_sold, sales_value, gross_profit
FROM retail_analytics.channel_sales
ORDER BY sales_value DESC;

-- 6. Jumlah SKU berdasarkan jenis risiko inventori.
SELECT flag, COUNT(*) AS flagged_skus
FROM retail_analytics.inventory_risk
GROUP BY flag
ORDER BY flagged_skus DESC;

-- 7. Validasi formula pada tabel detail.
SELECT COUNT(*) AS formula_mismatch
FROM retail_analytics.sales_transactions_enriched
WHERE ABS(
    total_value - ROUND(quantity * unit_price * (1 - discount_pct / 100), 2)
) > 0.02;

-- 8. Audit eksekusi ETL terbaru.
SELECT run_id, started_at, finished_at, source_variant,
       input_rows, output_rows, status, details
FROM retail_analytics.etl_audit
ORDER BY started_at DESC
LIMIT 10;

