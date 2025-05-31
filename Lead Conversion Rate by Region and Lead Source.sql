USE ev_manufacturer_database;

CREATE OR REPLACE VIEW vw_lead_conversion AS
SELECT region,
lead_source,
COUNT(customer_id) AS total_leads,
SUM(CASE WHEN status='Converted' THEN 1 ELSE 0 END) AS converted_leads,
ROUND( (SUM(CASE WHEN status='Converted' THEN 1 ELSE 0 END) /COUNT(customer_id) )* 100,2) AS conversion_rate_pct
FROM customer_leads
GROUP BY region,lead_source;

SELECT *
FROM vw_lead_conversion;