WITH rfm_base AS (
    SELECT
        ع.رقم_العميل                                                    AS customer_id,
        ع.اسم_العميل                                                    AS customer_name,
        ع.شريحة_العميل                                                  AS segment,
        ع.المدينة                                                        AS city,
        ع.النقاط                                                         AS points,
        MAX(ف.تاريخ_الفاتورة)                                           AS last_purchase,
        (DATE '2024-12-31' - MAX(ف.تاريخ_الفاتورة))                   AS days_since_last,
        COUNT(ف.رقم_الفاتورة)                                           AS frequency,
        ROUND(SUM(ف.الصافي), 2)                                         AS monetary,
        ROUND(AVG(ف.الصافي), 2)                                         AS avg_order
    FROM العملاء ع
    JOIN الفواتير ف ON ع.رقم_العميل = ف.رقم_العميل
    GROUP BY ع.رقم_العميل, ع.اسم_العميل,
             ع.شريحة_العميل, ع.المدينة, ع.النقاط
),
rfm_scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY days_since_last ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC)        AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)         AS m_score
    FROM rfm_base
)
SELECT
    customer_id,
    customer_name,
    segment,
    city,
    points,
    last_purchase,
    days_since_last,
    frequency,
    monetary,
    avg_order,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score)                                       AS rfm_total,
    ROUND(monetary * 3, 2)                                              AS clv_3yr_estimate,
    CASE
        WHEN (r_score + f_score + m_score) >= 13 THEN 'Gold Customer'
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Premium Customer'
        WHEN (r_score + f_score + m_score) >= 7  THEN 'Regular Customer'
        WHEN r_score <= 2                         THEN 'Dormant Customer'
        ELSE                                           'At-Risk Customer'
    END                                                                 AS rfm_label,
    PERCENT_RANK() OVER (ORDER BY monetary)                             AS monetary_percentile
FROM rfm_scored
ORDER BY rfm_total DESC;
 
 
