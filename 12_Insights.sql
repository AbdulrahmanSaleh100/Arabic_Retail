
SELECT
    م.اسم_المنتج                                                        AS product_name,
    ك.اسم_الفئة                                                         AS category,
    م.سعر_البيع                                                         AS unit_price,
    CASE
        WHEN م.سعر_البيع <  15  THEN 'Under EGP 15'
        WHEN م.سعر_البيع <  50  THEN 'EGP 15-49'
        WHEN م.سعر_البيع <  150 THEN 'EGP 50-149'
        WHEN م.سعر_البيع <  300 THEN 'EGP 150-299'
        ELSE                         'EGP 300+'
    END                                                                 AS price_tier,
    ROUND(AVG(ت.الكمية), 2)                                             AS avg_units_per_invoice,
    SUM(ت.الكمية)                                                        AS total_units,
    ROUND(SUM(ت.الإجمالي), 2)                                           AS total_revenue,
    COUNT(DISTINCT ت.رقم_الفاتورة)                                      AS invoices_containing
FROM تفاصيل_الفواتير ت
JOIN المنتجات م ON ت.رقم_المنتج = م.رقم_المنتج
JOIN الفئات   ك ON م.رقم_الفئة  = ك.رقم_الفئة
GROUP BY م.رقم_المنتج, م.اسم_المنتج, ك.اسم_الفئة, م.سعر_البيع
ORDER BY م.سعر_البيع;
 