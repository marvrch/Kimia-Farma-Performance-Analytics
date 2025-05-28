-- Displaying all the data in the Analyzing Table
SELECT *
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`;


-- Displaying the net sales compared from each year
SELECT EXTRACT(YEAR from date) AS Tahun,
SUM(nett_sales) AS NetSales
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY EXTRACT(YEAR from date)
ORDER BY Tahun;


-- Displaying the net profit compared from each year
SELECT EXTRACT(YEAR from date) AS Tahun,
SUM(nett_profit) AS NetProfit
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY EXTRACT(YEAR from date)
ORDER BY Tahun;


-- Displaying the top 10 province branches based on their net sales
SELECT provinsi AS Provinsi, 
SUM(nett_sales) AS NetSales
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` 
GROUP BY provinsi
ORDER BY NetSales DESC;


-- Displaying the top 10 province branches based on their transaction volume
SELECT provinsi AS Provinsi, 
COUNT(transaction_id) AS JumlahTransaksi
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` 
GROUP BY provinsi
ORDER BY JumlahTransaksi DESC;


-- Displaying the amount of products and branches
SELECT COUNT(DISTINCT product_id) AS JumlahProduk,
COUNT(DISTINCT branch_id) AS JumlahCabang
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`;


-- Displaying the top 5 branches with the highest branch rating but with the lowest transaction rating
SELECT kota,
AVG(rating_cabang) AS RatingCabang,
AVG(rating_transaksi) AS RatingTransaksi
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY kota
ORDER BY RatingCabang DESC, RatingTransaksi ASC
LIMIT 5;
 

-- Displaying the top 5 most sold products based on their transaction volume
WITH CTE AS (
  SELECT product_name,
  COUNT(t1.transaction_id) AS JumlahTransaksi,
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` t1
  GROUP BY product_name
  )
SELECT product_name,
  CTE.JumlahTransaksi,
  ROUND(100 * CTE.JumlahTransaksi/SUM(CTE.JumlahTransaksi) OVER(),2) AS Persentase
FROM CTE
ORDER BY JumlahTransaksi DESC
LIMIT 5;



-- Displaying the amount of transactions (All Year)
SELECT COUNT(DISTINCT transaction_id)
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`;


-- Displaying the total net sales (All Year)
SELECT SUM(nett_sales)
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`;


-- Displaying the total net sales per year 
SELECT EXTRACT(YEAR FROM date) AS Year,
SUM(nett_sales)
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY Year
ORDER BY Year ASC;


-- Displaying the total net profit per year
SELECT EXTRACT(YEAR FROM date) AS Year,
SUM(nett_profit)
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY Year
ORDER BY Year ASC;


-- Displaying the profit margin per year
SELECT EXTRACT(YEAR FROM date) AS Year,
CONCAT(CAST(ROUND(SUM(nett_profit)/SUM(nett_sales)*100,3) AS STRING), '%') AS Margin
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY Year
ORDER BY Year ASC;


-- Displaying the total net sales for each province
SELECT provinsi,
SUM(nett_sales) AS NetSales
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY provinsi
ORDER BY NetSales DESC;


-- Displaying the average transaction value for each province
WITH CTE AS(
SELECT provinsi,
SUM(nett_sales) AS NetSales,
COUNT(DISTINCT transaction_id) AS VolumeTransaksi
FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
GROUP BY provinsi
ORDER BY NetSales DESC
)
SELECT CTE.provinsi,
ROUND(CTE.NetSales/CTE.VolumeTransaksi,2) AS AvgNilaiTransaksi
FROM CTE
LIMIT 10;


-- Displaying the percentage of profit contribution from eastern provinces only
WITH CTE AS(
  SELECT provinsi,
  SUM(nett_profit) AS NetProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
  GROUP BY provinsi
  ORDER BY NetProfit DESC),
CTE2 AS(
  SELECT SUM(nett_profit) AS TotalProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
)
SELECT provinsi,
(CTE.NetProfit/CTE2.TotalProfit)*100 AS PersentaseKontribusiProfit
FROM CTE, CTE2
WHERE provinsi IN ('Bali',
'Nusa Tenggara Barat',
'Nusa Tenggara Timur',
'Sulawesi Utara',
'Gorontalo',
'Sulawesi Tengah',
'Sulawesi Barat',
'Sulawesi Selatan',
'Sulawesi Tenggara',
'Maluku Utara',
'Maluku',
'Papua Barat',
'Papua Barat Daya',
'Papua Pegunungan',
'Papua Tengah',
'Papua Selatan',
'Papua');


-- Displaying the sum percentage of profit contribution from eastern provinces only
WITH CTE1 AS(
  SELECT
  SUM(nett_profit) AS NetProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
  WHERE provinsi IN ('Bali',
  'Nusa Tenggara Barat',
  'Nusa Tenggara Timur',
  'Sulawesi Utara',
  'Gorontalo',
  'Sulawesi Tengah',
  'Sulawesi Barat',
  'Sulawesi Selatan',
  'Sulawesi Tenggara',
  'Maluku Utara',
  'Maluku',
  'Papua Barat',
  'Papua Barat Daya',
  'Papua Pegunungan',
  'Papua Tengah',
  'Papua Selatan',
  'Papua')
),
CTE2 AS(
  SELECT SUM(nett_profit) AS TotalProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` 
)
SELECT CTE1.NetProfit/CTE2.TotalProfit*100 AS PersentaseKontribusiProfit
FROM CTE1, CTE2;


-- Displaying the sum percentage of profit contribution excluding eastern provinces 
WITH CTE1 AS(
  SELECT
  SUM(nett_profit) AS NetProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table`
  WHERE provinsi NOT IN ('Bali',
  'Nusa Tenggara Barat',
  'Nusa Tenggara Timur',
  'Sulawesi Utara',
  'Gorontalo',
  'Sulawesi Tengah',
  'Sulawesi Barat',
  'Sulawesi Selatan',
  'Sulawesi Tenggara',
  'Maluku Utara',
  'Maluku',
  'Papua Barat',
  'Papua Barat Daya',
  'Papua Pegunungan',
  'Papua Tengah',
  'Papua Selatan',
  'Papua')
),
CTE2 AS(
  SELECT SUM(nett_profit) AS TotalProfit
  FROM `rakamin-ka-performanceanalysis.KimiaFarmaDataset.analyzing_table` 
)
SELECT CTE1.NetProfit/CTE2.TotalProfit*100
FROM CTE1, CTE2


