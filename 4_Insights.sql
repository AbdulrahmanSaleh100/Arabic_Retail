WITH product_sales AS (
    SELECT
        م.رقم_المنتج                                                    AS product_id,
        م.اسم_المنتج                                                    AS product_name,
        ك.اسم_الفئة                                                     AS category,
        م.سعر_البيع                                                     AS unit_price,
        م.هو_بيستسيلر                                                   AS is_bestseller,
        SUM(ت.الكمية)                                                    AS units_sold,
        ROUND(SUM(ت.الإجمالي), 2)                                       AS revenue,
        ROUND(SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة)), 2)       AS gross_profit,
        ROUND(100.0 * SUM(ت.الكمية * (م.سعر_البيع - م.سعر_التكلفة))
            / NULLIF(SUM(ت.الإجمالي), 0), 1)                           AS margin_pct
    FROM تفاصيل_الفواتير ت
    JOIN المنتجات م ON ت.رقم_المنتج = م.رقم_المنتج
    JOIN الفئات   ك ON م.رقم_الفئة  = ك.رقم_الفئة
    GROUP BY م.رقم_المنتج, م.اسم_المنتج, ك.اسم_الفئة,
             م.سعر_البيع, م.هو_بيستسيلر
)
SELECT
    ROW_NUMBER() OVER (ORDER BY revenue DESC)                           AS rank,
    product_id,
    product_name,
    category,
    unit_price,
    is_bestseller,
    units_sold,
    revenue,
    gross_profit,
    margin_pct,
    ROUND(100.0 * revenue / SUM(revenue) OVER (), 2)                   AS revenue_share_pct,
    ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        / SUM(revenue) OVER (), 2)                                     AS cumulative_pct,
    CASE
        WHEN ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
            / SUM(revenue) OVER (), 2) <= 70  THEN 'A — Star'
        WHEN ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
            / SUM(revenue) OVER (), 2) <= 90  THEN 'B — Normal'
        ELSE                                       'C — Long Tail'
    END                                                                 AS abc_class
FROM product_sales
ORDER BY revenue DESC;
 