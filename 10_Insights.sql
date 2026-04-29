
SELECT
    ب.رقم_الفرع                                                        AS branch_id,
    ب.اسم_الفرع                                                        AS branch_name,
    ب.مستوى_الأداء                                                     AS performance_tier,
    م.رقم_المنتج                                                        AS product_id,
    م.اسم_المنتج                                                        AS product_name,
    ك.اسم_الفئة                                                         AS category,
    م.سعر_البيع                                                         AS unit_price,
    م.هو_بيستسيلر                                                       AS is_bestseller,
    خ.الكمية_الحالية                                                    AS current_stock,
    خ.نقطة_إعادة_الطلب                                                  AS reorder_point,
    (خ.نقطة_إعادة_الطلب - خ.الكمية_الحالية)                           AS stock_deficit,
    ROUND((خ.نقطة_إعادة_الطلب - خ.الكمية_الحالية) * م.سعر_البيع, 2) AS potential_loss_egp,
    خ.آخر_تحديث                                                         AS last_updated,
    CASE
        WHEN خ.الكمية_الحالية = 0                                      THEN 'OUT OF STOCK'
        WHEN خ.الكمية_الحالية < خ.نقطة_إعادة_الطلب * 0.5             THEN 'CRITICAL'
        ELSE                                                                 'BELOW MINIMUM'
    END                                                                 AS risk_level,
    CASE
        WHEN خ.الكمية_الحالية = 0                                      THEN 3
        WHEN خ.الكمية_الحالية < خ.نقطة_إعادة_الطلب * 0.5             THEN 2
        ELSE                                                                 1
    END                                                                 AS risk_score
FROM المخزون خ
JOIN المنتجات م ON خ.رقم_المنتج = م.رقم_المنتج
JOIN الفئات   ك ON م.رقم_الفئة  = ك.رقم_الفئة
JOIN الفروع   ب ON خ.رقم_الفرع  = ب.رقم_الفرع
WHERE خ.الكمية_الحالية < خ.نقطة_إعادة_الطلب
ORDER BY potential_loss_egp DESC, risk_score DESC;