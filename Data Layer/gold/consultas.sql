-- ============================================================================
-- GOLD LAYER – CONSULTAS ANALÍTICAS (MODELO ABREVIADO)
-- ============================================================================

-- ============================================================================
-- 1. VERIFICAÇÃO DO SCHEMA GOLD
-- ============================================================================
SELECT 'dim_cmp' AS tabela, COUNT(*) AS linhas FROM gold.dim_cmp
UNION ALL
SELECT 'dim_frd' AS tabela, COUNT(*) AS linhas FROM gold.dim_frd
UNION ALL
SELECT 'dim_jtl' AS tabela, COUNT(*) AS linhas FROM gold.dim_jtl
UNION ALL
SELECT 'dim_loc' AS tabela, COUNT(*) AS linhas FROM gold.dim_loc
UNION ALL
SELECT 'fact_jpt' AS tabela, COUNT(*) AS linhas FROM gold.fact_jpt
ORDER BY tabela;

-- ============================================================================
-- 2. TOTAL DE VAGAS POR TIPO (FAKE × REAL)
-- ============================================================================
SELECT
    is_fake,
    COUNT(*) AS total_vagas,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_total
FROM gold.fact_jpt
GROUP BY is_fake;

-- ============================================================================
-- 3. TOP 10 EMPRESAS COM MAIS VAGAS FALSAS
-- ============================================================================
SELECT
    c.cmp_nam,
    COUNT(*) AS vagas_falsas
FROM gold.fact_jpt f
JOIN gold.dim_cmp c
    ON f.cmp_srk = c.cmp_srk
WHERE f.is_fake = TRUE
GROUP BY c.cmp_nam
ORDER BY vagas_falsas DESC
LIMIT 10;

-- ============================================================================
-- 4. EMPRESAS COM VAGAS VERDADEIRAS
-- ============================================================================
SELECT
    c.cmp_nam,
    COUNT(*) AS vagas
FROM gold.fact_jpt f
JOIN gold.dim_cmp c
    ON f.cmp_srk = c.cmp_srk
WHERE f.is_fake = FALSE
GROUP BY c.cmp_nam
ORDER BY vagas DESC;

-- ============================================================================
-- 5. CARGOS MAIS AFETADOS POR FRAUDE
-- ============================================================================
SELECT
    j.jtl,
    COUNT(*) AS total_vagas,
    SUM(CASE WHEN f.is_fake THEN 1 ELSE 0 END) AS vagas_falsas,
    ROUND(
        100.0 * SUM(CASE WHEN f.is_fake THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS pct_fraude
FROM gold.fact_jpt f
JOIN gold.dim_jtl j
    ON f.jtl_srk = j.jtl_srk
GROUP BY j.jtl
HAVING COUNT(*) >= 10
ORDER BY pct_fraude DESC;

-- ============================================================================
-- 6. DISTRIBUIÇÃO DE VAGAS POR PAÍS / ESTADO
-- ============================================================================
SELECT
    l.cty,
    l.ste,
    COUNT(*) AS total_vagas
FROM gold.fact_jpt f
JOIN gold.dim_loc l
    ON f.loc_srk = l.loc_srk
GROUP BY l.cty, l.ste
ORDER BY total_vagas DESC;

-- ============================================================================
-- 7. TRABALHO REMOTO × PRESENCIAL
-- ============================================================================
SELECT
    rmt,
    COUNT(*) AS total_vagas,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_total
FROM gold.fact_jpt
GROUP BY rmt;

-- ============================================================================
-- 8. PRINCIPAIS MOTIVOS DE FRAUDE
-- ============================================================================
SELECT
    r.frd,
    COUNT(*) AS ocorrencias
FROM gold.fact_jpt f
JOIN gold.dim_frd r
    ON f.frd_srk = r.frd_srk
WHERE f.is_fake = TRUE
GROUP BY r.frd
ORDER BY ocorrencias DESC;

-- ============================================================================
-- 9. FRAUDE × REMOTO
-- ============================================================================
WITH base AS (
    SELECT
        rmt,
        is_fake
    FROM gold.fact_jpt
)
SELECT
    rmt,
    COUNT(*) AS total_vagas,
    SUM(CASE WHEN is_fake THEN 1 ELSE 0 END) AS vagas_falsas,
    ROUND(
            100.0 * SUM(CASE WHEN is_fake THEN 1 ELSE 0 END) / COUNT(*),
            2
    ) AS pct_fraude
FROM base
GROUP BY rmt;


-- ============================================================================
-- 10. SALÁRIO MÉDIO: REMOTO × PRESENCIAL
-- ============================================================================
SELECT
    rmt,
    ROUND(AVG(avg), 2) AS salario_medio
FROM gold.fact_jpt
WHERE avg IS NOT NULL
GROUP BY rmt;
