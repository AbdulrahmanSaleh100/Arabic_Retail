SELECT
    ب.رقم_الفرع                                                        AS branch_id,
    ب.اسم_الفرع                                                        AS branch_name,
    ب.المدينة                                                           AS city,
    ب.المنطقة                                                           AS region,
    ب.مستوى_الأداء                                                     AS performance_tier,
    COUNT(DISTINCT ف.رقم_العميل)                                        AS unique_customers,
    COUNT(ف.رقم_الفاتورة)                                               AS invoices,
    ROUND(SUM(ف.الصافي), 2)                                             AS revenue,
    ROUND(AVG(ف.الصافي), 2)                                             AS avg_order,
    ROUND(SUM(ف.الخصم), 2)                                              AS discounts_given,
    ROUND(SUM(ف.الصافي) / NULLIF(COUNT(DISTINCT ف.رقم_العميل),0), 2)  AS revenue_per_customer,
    COUNT(CASE WHEN ف.طريقة_الدفع = 'نقدي'   THEN 1 END)             AS cash_txns,
    COUNT(CASE WHEN ف.طريقة_الدفع = 'بطاقة'  THEN 1 END)             AS card_txns,
    COUNT(CASE WHEN ف.طريقة_الدفع = 'أونلاين' THEN 1 END)            AS online_txns,
    RANK() OVER (ORDER BY SUM(ف.الصافي) DESC)                          AS revenue_rank,
    ROUND(100.0 * SUM(ف.الصافي) / SUM(SUM(ف.الصافي)) OVER (), 2)     AS market_share_pct,
    ROUND(100.0 * SUM(ف.الصافي)
        / MAX(SUM(ف.الصافي)) OVER (), 1)                               AS pct_of_best_branch
FROM الفروع ب
LEFT JOIN الفواتير ف ON ب.رقم_الفرع = ف.رقم_الفرع
GROUP BY ب.رقم_الفرع, ب.اسم_الفرع, ب.المدينة,
         ب.المنطقة, ب.مستوى_الأداء
ORDER BY revenue DESC;
 
 
