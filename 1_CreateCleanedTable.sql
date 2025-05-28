-- Create a new table for kf_final_transaction and perform data type conversion (FLOAT -> DECIMAL) using CAST function
CREATE OR REPLACE TABLE `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_final_transaction_cleaned` AS
SELECT 
  transaction_id,
  DATE(date) AS date,
  branch_id,
  customer_name,
  product_id,
  CAST(price AS DECIMAL) AS price,
  CAST(discount_percentage AS DECIMAL) AS discount_percentage,
  CAST(rating as DECIMAL) AS rating
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_final_transaction`
WHERE price IS NOT NULL AND discount_percentage IS NOT NULL;


-- Create a new table for kf_product
CREATE OR REPLACE TABLE `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_product_cleaned` AS
SELECT 
  product_id,
  product_name,
  product_category,
  CAST(price AS DECIMAL) AS price,
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_product`
WHERE price IS NOT NULL;


-- Create a new table for kf_inventory
CREATE OR REPLACE TABLE `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_inventory_cleaned` AS
SELECT 
  inventory_id,
  branch_id,
  product_id,
  product_name,
  CAST(opname_stock AS INTEGER) AS opname_stock,
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_inventory`
WHERE opname_stock IS NOT NULL;


-- Create a new table for kf_kantor_cabang
CREATE OR REPLACE TABLE `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_kantor_cabang_cleaned` AS
SELECT 
  branch_id,
  branch_category,
  branch_name,
  kota,
  provinsi,
  CAST(rating AS DECIMAL) AS rating,
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.kf_kantor_cabang`
WHERE rating IS NOT NULL;



