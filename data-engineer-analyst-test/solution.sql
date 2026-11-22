-- BODY CODE
WITH
TEMPLATE_ROWS AS (
    SELECT
        Label,
        UPPER(TRIM(Label)) = 'TOTAL' AS is_total,
        TRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        UPPER(Label),
                        CHAR(237), 'I'
                    ),
                    CHAR(205), 'I'
                ),
                CHAR(769), ''
            )
        ) AS clean_label
    FROM weekly_kpi_w46
    WHERE Week = '2026-W46'
),

-- 1. VISITAS Y RSAs TRAINED (dividiendo 'WEAR & XR' en 'WEAR' y 'XR')
EXPANDED_FV AS (
    SELECT
        CASE
            WHEN fv.product_focus = 'WEAR & XR' THEN 'WEAR'
            ELSE fv.product_focus
        END AS product_focus,
        sm.retailer,
        COALESCE(fv.rsas_trained, 0) AS rsas_trained
    FROM field_visits fv
    LEFT JOIN store_master sm
        ON fv.store_code = sm.store_code
    WHERE fv.status = 'COMPLETED'
      AND fv.checkin_at >= '2026-11-08'
      AND fv.checkout_at < '2026-11-15'
      AND fv.product_focus IN ('WEAR', 'XR', 'WEAR & XR')

    UNION ALL

    SELECT
        'XR' AS product_focus,
        sm.retailer,
        COALESCE(fv.rsas_trained, 0) AS rsas_trained
    FROM field_visits fv
    LEFT JOIN store_master sm
        ON fv.store_code = sm.store_code
    WHERE fv.status = 'COMPLETED'
      AND fv.checkin_at >= '2026-11-08'
      AND fv.checkout_at < '2026-11-15'
      AND fv.product_focus = 'WEAR & XR'
),

AGG_FV AS (
    SELECT
        TRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        UPPER(product_focus || ' ' || COALESCE(retailer, '')),
                        CHAR(237), 'I'
                    ),
                    CHAR(205), 'I'
                ),
                CHAR(769), ''
            )
        ) AS clean_label,
        COUNT(*) AS n_visits,
        SUM(rsas_trained) AS n_trainers
    FROM EXPANDED_FV
    GROUP BY clean_label
),

-- 2. UNIDADES VENDIDAS (SELL-OUT)
AGG_SELL AS (
    SELECT
        TRIM(
            REPLACE(
                REPLACE(
                    REPLACE(
                        UPPER(COALESCE(PM.product_line, '') || ' ' || COALESCE(RS.retailer, '')),
                        CHAR(237), 'I'
                    ),
                    CHAR(205), 'I'
                ),
                CHAR(769), ''
            )
        ) AS clean_label,
        SUM(COALESCE(RS.units, 0)) AS total_units
    FROM retailer_sellout RS
    LEFT JOIN product_master PM
        ON PM.SKU = RS.SKU
    WHERE RS.week_ending = '2026-11-14'
    GROUP BY clean_label
),

-- 3. MÉTRICAS POR FILA DE PLANTILLA
DETAIL_METRICS AS (
    SELECT
        t.Label,
        t.clean_label,
        COALESCE(f.n_visits, 0) AS n_visits,
        COALESCE(f.n_trainers, 0) AS n_trainers,
        COALESCE(s.total_units, 0) AS total_units
    FROM TEMPLATE_ROWS t
    LEFT JOIN AGG_FV f
        ON t.clean_label = f.clean_label
    LEFT JOIN AGG_SELL s
        ON t.clean_label = s.clean_label
    WHERE NOT t.is_total
),

-- 4. TOTAL CALCULADO A PARTIR DEL DETALLE
TOTAL_METRICS AS (
    SELECT
        'TOTAL' AS clean_label,
        COALESCE(SUM(n_visits), 0) AS n_visits,
        COALESCE(SUM(n_trainers), 0) AS n_trainers,
        COALESCE(SUM(total_units), 0) AS total_units
    FROM DETAIL_METRICS
),

METRICAS_UNIDAS AS (
    SELECT
        clean_label,
        n_visits,
        n_trainers,
        total_units
    FROM DETAIL_METRICS

    UNION ALL

    SELECT
        clean_label,
        n_visits,
        n_trainers,
        total_units
    FROM TOTAL_METRICS
)

-- ACTUALIZACIÓN EN UN SOLO PASO (DETALLE + TOTAL)
UPDATE weekly_kpi_w46 AS w
SET
    Visits = m.n_visits,
    "RSAs Trained" = m.n_trainers,
    "Sell-out Units" = m.total_units
FROM METRICAS_UNIDAS AS m
WHERE w.Week = '2026-W46'
  AND CASE
          WHEN UPPER(TRIM(w.Label)) = 'TOTAL' THEN 'TOTAL'
          ELSE TRIM(
              REPLACE(
                  REPLACE(
                      REPLACE(
                          UPPER(w.Label),
                          CHAR(237), 'I'
                      ),
                      CHAR(205), 'I'
                  ),
                  CHAR(769), ''
              )
          )
      END = m.clean_label;

-- VIEW FINAL RESULT
SELECT *
FROM weekly_kpi_w46
WHERE Week = '2026-W46';