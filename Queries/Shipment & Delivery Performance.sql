-- 1.1 Find total shipments, completed, active, and returned --

SELECT 
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END) AS completed_shipments,
    SUM(CASE WHEN Status = 'Active' THEN 1 ELSE 0 END) AS active_shipments,
    SUM(CASE WHEN Status = 'Returned' THEN 1 ELSE 0 END) AS returned_shipments
FROM Shipment;

-- 1.2 Monthly shipment trends (Active, Completed, Returned) --

SELECT 
    TO_CHAR(Date, 'Month') AS shipment_month_name,
    Status,
    COUNT(*) AS shipment_count
FROM Shipment
GROUP BY shipment_month_name, Status
ORDER BY shipment_month_name, Status;

-- 1.3 Average delivery time by country (only where "Delivered On" is NOT NULL) --

SELECT 
    s.Geography,
    ROUND(AVG("Delivered On" - Date),2) AS average_delivery_days
FROM Shipment s
WHERE "Delivered On" IS NOT NULL
GROUP BY s.Geography
ORDER BY average_delivery_days DESC;

-- 1.4 Countries with the highest return rates --

SELECT 
    s.Geography,
    COUNT(*) FILTER (WHERE Status = 'Returned') AS returned_shipments,
    COUNT(*) AS total_shipments,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE Status = 'Returned') / COUNT(*), 
        2
    ) AS return_rate_percentage
FROM Shipment s
GROUP BY s.Geography
ORDER BY return_rate_percentage DESC;