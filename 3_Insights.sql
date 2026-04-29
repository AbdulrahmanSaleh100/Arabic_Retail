SELECT
    ك.اسم_الفئة                                                        AS category,
    ك.موسمية                                                            AS seasonality_note,
    EXTRACT(MONTH FROM ف.تاريخ_الفاتورة)::INT                          AS month_num,
    TO_CHAR(ف.تاريخ_الفاتورة, 'Mon')                                   AS month_label,
    ROUND(SUM(ت.الإجمالي), 2)                                          AS revenue,
    SUM(ت.الكمية)                                                       AS units_sold,
    ROUND(
        SUM(ت.الإجمالي) * 100.0
        / NULLIF(SUM(SUM(ت.الإجمالي))
            OVER (PARTITION BY ك.رقم_الفئة), 0), 1
    )                                                                   AS pct_of_annual
FROM تفاصيل_الفواتير ت
JOIN الفواتير  ف ON ت.رقم_الفاتورة = ف.رقم_الفاتورة
JOIN المنتجات  م ON ت.رقم_المنتج   = م.رقم_المنتج
JOIN الفئات    ك ON م.رقم_الفئة    = ك.رقم_الفئة
GROUP BY ك.رقم_الفئة, ك.اسم_الفئة, ك.موسمية,
         EXTRACT(MONTH FROM ف.تاريخ_الفاتورة),
         TO_CHAR(ف.تاريخ_الفاتورة, 'Mon')
ORDER BY ك.اسم_الفئة, month_num;
 