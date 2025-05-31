USE ev_manufacturer_database;

CREATE OR REPLACE VIEW vw_campaign_performance AS
SELECT campaign_name,
channel,
start_date,
end_date,
cost,
impressions,
clicks,
conversions,
ROUND((clicks/impressions)*100,2) AS ctr_pct,
ROUND((conversions/clicks)*100,2) AS conversion_rate_pct,
ROUND((cost/conversions),2) AS cost_per_conversion
FROM campaigns;

SELECT *
FROM vw_campaign_performance
