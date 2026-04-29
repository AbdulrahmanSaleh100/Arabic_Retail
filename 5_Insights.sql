SELECT
    ك.اسم_الفئة                                                        AS category,
    ك.موسمية                                                            AS seasonality,
    ك.هامش_الربح                                                        AS target_margin_pct,
    COUNT(DISTINCT م.رقم_المنتج)                                        AS num_products,
    SUM(ت.الكمية)                                                       AS total_units,
    ROUND(SUM(ت.الكمية * م.سعر_البيع), 2)                              AS revenue,
    ROUND(SUM(ت.الكمية * م.سعر_التكلفة), 2)                            AS cost,
    ROUND(SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة)), 2)           AS gross_profit,
    ROUND(100.0 * SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة))
        / NULLIF(SUM(ت.الكمية * م.سعر_البيع), 0), 1)                  AS actual_margin_pct,
    ROUND(100.0 * SUM(ت.الكمية * م.سعر_البيع)
        / SUM(SUM(ت.الكمية * م.سعر_البيع)) OVER (), 1)                AS revenue_share_pct,
    CASE
        WHEN ROUND(100.0 * SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة))
            / NULLIF(SUM(ت.الكمية * م.سعر_البيع),0),1) >= 45
            THEN 'High Margin'
        WHEN ROUND(100.0 * SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة))
            / NULLIF(SUM(ت.الكمية * م.سعر_البيع),0),1) >= 25
            THEN 'Medium Margin'
        ELSE 'Low Margin'
    END                                                                 AS margin_tier
FROM تفاصيل_الفواتير ت
JOIN المنتجات م ON ت.رقم_المنتج = م.رقم_المنتج
JOIN الفئات   ك ON م.رقم_الفئة  = ك.رقم_الفئة
GROUP BY ك.رقم_الفئة, ك.اسم_الفئة, ك.موسمية, ك.هامش_الربح
ORDER BY gross_profit DESC;
 