SELECT
    EXTRACT(MONTH FROM ف.تاريخ_الفاتورة)::INT                          AS month_num,
    TO_CHAR(ف.تاريخ_الفاتورة, 'Mon YYYY')                              AS month_label,
    ف.طريقة_الدفع                                                       AS payment_method,
    ع.شريحة_العميل                                                      AS segment,
    COUNT(*)                                                            AS txn_count,
    ROUND(SUM(ف.الصافي), 2)                                             AS revenue,
    ROUND(AVG(ف.الصافي), 2)                                             AS avg_value,
    ROUND(100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER (
            PARTITION BY EXTRACT(MONTH FROM ف.تاريخ_الفاتورة),
                         ع.شريحة_العميل), 1)                           AS method_share_pct
FROM الفواتير ف
JOIN العملاء ع ON ف.رقم_العميل = ع.رقم_العميل
GROUP BY 1, 2, 3, 4
ORDER BY month_num, segment, payment_method;
