CREATE SCHEMA IF NOT EXISTS retail_analytics;

CREATE TABLE IF NOT EXISTS retail_analytics.monthly_sales (
    month date PRIMARY KEY,
    line_items bigint NOT NULL,
    receipts bigint NOT NULL,
    units_sold bigint NOT NULL,
    sales_value numeric(20, 2) NOT NULL,
    gross_profit numeric(20, 2)
);

CREATE TABLE IF NOT EXISTS retail_analytics.store_sales (
    store_id varchar(10) PRIMARY KEY,
    store_name text NOT NULL,
    store_city text NOT NULL,
    store_type text NOT NULL,
    line_items bigint NOT NULL,
    receipts bigint NOT NULL,
    units_sold bigint NOT NULL,
    sales_value numeric(20, 2) NOT NULL,
    gross_profit numeric(20, 2)
);

CREATE TABLE IF NOT EXISTS retail_analytics.category_sales (
    category text NOT NULL,
    subcategory text NOT NULL,
    line_items bigint NOT NULL,
    receipts bigint NOT NULL,
    units_sold bigint NOT NULL,
    sales_value numeric(20, 2) NOT NULL,
    gross_profit numeric(20, 2),
    PRIMARY KEY (category, subcategory)
);

CREATE TABLE IF NOT EXISTS retail_analytics.channel_sales (
    channel text PRIMARY KEY,
    line_items bigint NOT NULL,
    receipts bigint NOT NULL,
    units_sold bigint NOT NULL,
    sales_value numeric(20, 2) NOT NULL,
    gross_profit numeric(20, 2)
);

CREATE TABLE IF NOT EXISTS retail_analytics.inventory_risk (
    sku_id varchar(20) NOT NULL,
    flag text NOT NULL,
    affected_stores text,
    window_start date,
    window_end date,
    notes text,
    PRIMARY KEY (sku_id, flag)
);

CREATE TABLE IF NOT EXISTS retail_analytics.etl_audit (
    run_id bigserial PRIMARY KEY,
    started_at timestamptz NOT NULL,
    finished_at timestamptz,
    source_variant text NOT NULL,
    input_rows bigint,
    output_rows bigint,
    status text NOT NULL,
    details text
);

-- Tabel detail bersifat opsional karena dapat berisi hampir 10 juta baris.
CREATE TABLE IF NOT EXISTS retail_analytics.sales_transactions_enriched (
    date date NOT NULL,
    receipt_id varchar(30) NOT NULL,
    store_id varchar(10) NOT NULL,
    sku_id varchar(20) NOT NULL,
    customer_id varchar(20) NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(14, 2) NOT NULL,
    total_value numeric(16, 2) NOT NULL,
    channel text NOT NULL,
    discount_pct numeric(7, 2) NOT NULL,
    promo_id varchar(20),
    store_name text,
    store_city text,
    store_type text,
    sku_name text,
    category text,
    subcategory text,
    brand text,
    loyalty_segment text,
    gross_sales numeric(16, 2),
    discount_amount numeric(16, 2),
    gross_profit numeric(16, 2),
    year integer,
    month_key char(7)
);

CREATE INDEX IF NOT EXISTS idx_sales_enriched_date
    ON retail_analytics.sales_transactions_enriched (date);
CREATE INDEX IF NOT EXISTS idx_sales_enriched_store
    ON retail_analytics.sales_transactions_enriched (store_id);
CREATE INDEX IF NOT EXISTS idx_sales_enriched_sku
    ON retail_analytics.sales_transactions_enriched (sku_id);

