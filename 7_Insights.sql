
SELECT
    ع.شريحة_العميل                                                     AS segment,
    COUNT(DISTINCT ع.رقم_العميل)                                        AS customer_count,
    COUNT(ف.رقم_الفاتورة)                                               AS total_invoices,
    ROUND(SUM(ف.الصافي), 2)                                             AS total_revenue,
    ROUND(AVG(ف.الصافي), 2)                                             AS avg_order_value,
    ROUND(SUM(ف.الصافي) / NULLIF(COUNT(DISTINCT ع.رقم_العميل), 0), 2) AS revenue_per_customer,
    ROUND(COUNT(ف.رقم_الفاتورة) * 1.0
        / NULLIF(COUNT(DISTINCT ع.رقم_العميل), 0), 1)                  AS avg_visits_per_customer,
    ROUND(AVG(ع.النقاط), 0)                                             AS avg_loyalty_points,
    ROUND(100.0 * SUM(ف.الصافي)
        / SUM(SUM(ف.الصافي)) OVER (), 1)                               AS revenue_share_pct,
    ROUND(100.0 * COUNT(DISTINCT ع.رقم_العميل)
        / SUM(COUNT(DISTINCT ع.رقم_العميل)) OVER (), 1)                AS customer_share_pct
FROM العملاء ع
LEFT JOIN الفواتير ف ON ع.رقم_العميل = ف.رقم_العميل
GROUP BY ع.شريحة_العميل
ORDER BY total_revenue DESC;