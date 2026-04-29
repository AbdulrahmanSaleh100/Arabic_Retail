SELECT
    م1.اسم_المنتج                                                       AS product_a,
    م2.اسم_المنتج                                                       AS product_b,
    COUNT(*)                                                            AS co_purchase_count,
    ROUND(100.0 * COUNT(*)
        / (SELECT COUNT(DISTINCT رقم_الفاتورة) FROM الفواتير), 2)      AS affinity_pct
FROM تفاصيل_الفواتير ت1
JOIN تفاصيل_الفواتير ت2
    ON ت1.رقم_الفاتورة = ت2.رقم_الفاتورة
    AND ت1.رقم_المنتج < ت2.رقم_المنتج
JOIN المنتجات م1 ON ت1.رقم_المنتج = م1.رقم_المنتج
JOIN المنتجات م2 ON ت2.رقم_المنتج = م2.رقم_المنتج
GROUP BY م1.اسم_المنتج, م2.اسم_المنتج
HAVING COUNT(*) >= 3
ORDER BY co_purchase_count DESC
LIMIT 25;
 
 
