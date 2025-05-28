-- Display the relevant attributes that will be used later in data analysis
SELECT 
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  CAST(ft.discount_percentage AS DECIMAL) AS discount_percentage,
  -- using CASE WHEN to handle multiple conditions
  CAST(CASE 
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END AS DECIMAL) AS persentase_gross_laba,
  CAST(ft.price*(1-ft.discount_percentage) AS DECIMAL) AS nett_sales,
  CAST(ft.price*(1-ft.discount_percentage)* 
  CASE 
    WHEN p.price <=50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END AS DECIMAL) AS nett_profit,
  CAST(ft.rating AS DECIMAL) AS rating_transaksi
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_final_transaction_cleaned` ft
JOIN `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_kantor_cabang_cleaned` kc ON kc.branch_id = ft.branch_id
JOIN `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_product_cleaned` p ON p.product_id = ft.product_id;


-- Create a new table to store all of the relevant attributes
CREATE OR REPLACE TABLE `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` AS
SELECT 
  ft.transaction_id,
  ft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  p.product_id,
  p.product_name,
  p.price AS actual_price,
  CAST(ft.discount_percentage AS DECIMAL) AS discount_percentage,
  CAST(CASE 
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END AS DECIMAL) AS persentase_gross_laba,
  CAST(ft.price*(1-ft.discount_percentage) AS DECIMAL) AS nett_sales,
  CAST(ft.price*(1-ft.discount_percentage)* 
  CASE 
    WHEN p.price <=50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 500000 THEN 0.3
  END AS DECIMAL) AS nett_profit,
  CAST(ft.rating AS DECIMAL) AS rating_transaksi
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_final_transaction_cleaned` ft
JOIN `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_kantor_cabang_cleaned` kc ON kc.branch_id = ft.branch_id
JOIN `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_product_cleaned` p ON p.product_id = ft.product_id;

