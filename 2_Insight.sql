SELECT
    EXTRACT(YEAR  FROM تاريخ_الفاتورة)::INT                            AS year,
    EXTRACT(MONTH FROM تاريخ_الفاتورة)::INT                            AS month_num,
    TO_CHAR(تاريخ_الفاتورة, 'Mon YYYY')                                AS month_label,
    COUNT(رقم_الفاتورة)                                                 AS invoices,
    ROUND(SUM(الصافي), 2)                                               AS revenue,
    ROUND(AVG(الصافي), 2)                                               AS avg_order,
    ROUND(SUM(الصافي) - LAG(SUM(الصافي))
        OVER (ORDER BY EXTRACT(YEAR FROM تاريخ_الفاتورة),
                       EXTRACT(MONTH FROM تاريخ_الفاتورة)), 2)         AS mom_change,
    ROUND(
        100.0 * (SUM(الصافي) - LAG(SUM(الصافي))
            OVER (ORDER BY EXTRACT(YEAR FROM تاريخ_الفاتورة),
                           EXTRACT(MONTH FROM تاريخ_الفاتورة)))
        / NULLIF(LAG(SUM(الصافي))
            OVER (ORDER BY EXTRACT(YEAR FROM تاريخ_الفاتورة),
                           EXTRACT(MONTH FROM تاريخ_الفاتورة)), 0), 1) AS mom_growth_pct
FROM الفواتير
GROUP BY 1, 2, 3
ORDER BY 1, 2;


