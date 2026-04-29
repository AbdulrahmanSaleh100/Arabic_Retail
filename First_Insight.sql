SELECT
    COUNT(DISTINCT ف.رقم_الفاتورة)                                     AS total_invoices,
    COUNT(DISTINCT ف.رقم_العميل)                                        AS active_customers,
    ROUND(SUM(ف.الصافي), 2)                                             AS total_revenue,
    ROUND(AVG(ف.الصافي), 2)                                             AS avg_order_value,
    ROUND(SUM(ف.الخصم), 2)                                              AS total_discounts,
    ROUND(100.0 * SUM(ف.الخصم) / NULLIF(SUM(ف.الإجمالي),0), 2)       AS discount_rate_pct,
    ROUND(
        SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة)), 2
    )                                                                   AS gross_profit,
    ROUND(
        100.0 * SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة))
        / NULLIF(SUM(ت.الكمية * م.سعر_البيع), 0), 2
    )                                                                   AS gross_margin_pct
FROM الفواتير ف
JOIN تفاصيل_الفواتير ت ON ف.رقم_الفاتورة = ت.رقم_الفاتورة
JOIN المنتجات م         ON ت.رقم_المنتج   = م.رقم_المنتج;