USE ev_manufacturer_database;

CREATE OR REPLACE VIEW vw_ev_dashboard AS
SELECT
    s.region,
    s.sale_year,
    s.sale_month,
    s.manufacturer,
    s.total_units_sold,
    s.total_revenue,
    l.total_leads,
    l.converted_leads,
    l.conversion_rate_pct,
    c.cost,
    c.impressions,
    c.clicks,
    c.conversions,
    c.ctr_pct,
    c.conversion_rate_pct AS campaign_conversion_rate,
    c.cost_per_conversion
FROM vw_vehicle_sales_summary s
LEFT JOIN (
    SELECT region, YEAR(conversion_date) AS conv_year, MONTH(conversion_date) AS conv_month, 
           COUNT(customer_id) AS total_leads, 
           SUM(CASE WHEN status = 'Converted' THEN 1 ELSE 0 END) AS converted_leads,
           ROUND((SUM(CASE WHEN status = 'Converted' THEN 1 ELSE 0 END) / COUNT(customer_id)) * 100, 2) AS conversion_rate_pct
    FROM customer_leads
    WHERE conversion_date IS NOT NULL
    GROUP BY region, conv_year, conv_month
) l ON s.region = l.region AND s.sale_year = l.conv_year AND s.sale_month = l.conv_month
LEFT JOIN (
    SELECT region, YEAR(start_date) AS camp_year, MONTH(start_date) AS camp_month,
           SUM(cost) AS cost,
           SUM(impressions) AS impressions,
           SUM(clicks) AS clicks,
           SUM(conversions) AS conversions,
           ROUND((SUM(clicks) / SUM(impressions)) * 100, 2) AS ctr_pct,
           ROUND((SUM(conversions) / SUM(clicks)) * 100, 2) AS conversion_rate_pct,
           ROUND((SUM(cost) / SUM(conversions)), 2) AS cost_per_conversion
    FROM campaigns c
    JOIN vehicle_sales v ON c.channel = 'Online' AND v.region = c.channel -- adjust join logic as per actual relation
    GROUP BY region, camp_year, camp_month
) c ON s.region = c.region AND s.sale_year = c.camp_year AND s.sale_month = c.camp_month;

SELECT *
FROM vw_ev_dashboard;
