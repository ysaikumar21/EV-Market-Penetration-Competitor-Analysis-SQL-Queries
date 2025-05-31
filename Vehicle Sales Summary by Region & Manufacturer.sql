USE ev_manufacturer_database;

CREATE OR REPLACE VIEW vw_vehicle_sales_summary AS 
SELECT region,
manufacturer,
YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
SUM(units_sold) AS total_units_sold,
SUM(revenue) AS total_revenue,
AVG(discount_applied) AS avg_discount
FROM vehicle_sales
GROUP BY region,manufacturer,sale_year,sale_month;

select *
from vw_vehicle_sales_summary;