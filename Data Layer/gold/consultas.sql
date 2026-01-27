-- ============================================================================
-- GOLD LAYER: CONSULTAS ANALÍTICAS
-- ============================================================================

-- ============================================================================
-- 1. VERIFICAÇÃO DO SCHEMA GOLD
-- ==================================================
SELECT 'dim_company' AS tabela, COUNT(*) AS linhas FROM gold.dim_company
UNION ALL
SELECT 'dim_fraud_reason' AS tabela, COUNT(*) AS linhas FROM gold.dim_fraud_reason
UNION ALL
SELECT 'dim_job_title' AS tabela, COUNT(*) AS linhas FROM gold.dim_job_title
UNION ALL
SELECT 'dim_location' AS tabela, COUNT(*) AS linhas FROM gold.dim_location
UNION ALL
SELECT 'fact_job_posting' AS tabela, COUNT(*) AS linhas FROM gold.fact_job_posting
ORDER BY tabela;

-- ============================================================================
-- 2. Lista o total de vagas por tipo de vaga
-- ==================================================
SELECT
    is_fake,
    COUNT(*) AS total_vagas,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_total
FROM gold.fact_job_posting
GROUP BY is_fake;

-- ============================================================================
-- 3. Mostra as 10 empresas com mais vagas falsas
-- ==================================================
SELECT
    c.company_name,
    COUNT(*) AS vagas_falsas
FROM gold.fact_job_posting f
         JOIN gold.dim_company c ON f.company_srk = c.company_sk
WHERE f.is_fake = TRUE
GROUP BY c.company_name
ORDER BY vagas_falsas DESC
LIMIT 10;


-- ============================================================================
-- 4. Mostra as empresas com vagas verdadeiras e sua quantidade de vagas
-- ==================================================
SELECT
    c.company_name,
    COUNT(*) AS vagas
FROM gold.fact_job_posting f
         JOIN gold.dim_company c ON f.company_srk = c.company_sk
WHERE f.is_fake = false
GROUP BY c.company_name
ORDER BY vagas DESC

-- ============================================================================
-- 5. Cargos mais afetados por fraude
-- ==================================================
SELECT
    j.job_title,
    COUNT(*) AS total_vagas,
    SUM(CASE WHEN f.is_fake THEN 1 ELSE 0 END) AS vagas_falsas,
    ROUND(100.0 * SUM(CASE WHEN f.is_fake THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_fraude
FROM gold.fact_job_posting f
         JOIN gold.dim_job_title j ON f.job_title_srk = j.job_title_sk
GROUP BY j.job_title
HAVING COUNT(*) >= 10
ORDER BY pct_fraude DESC;

-- ============================================================================
-- 6. Distribuição de vagas por país / estado
-- ==================================================

SELECT
    l.country,
    l.state,
    COUNT(*) AS total_vagas
FROM gold.fact_job_posting f
         JOIN gold.dim_location l ON f.location_srk = l.location_sk
GROUP BY l.country, l.state
ORDER BY total_vagas DESC;

-- ============================================================================
-- 7. Trabalho remoto vs presencial
-- ==================================================--
SELECT
    remote,
    COUNT(*) AS total_vagas,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_total
FROM gold.fact_job_posting
GROUP BY remote;

-- ============================================================================
-- 8. Principais motivos de fraude
-- ==================================================
SELECT
    r.fraud_reason,
    COUNT(*) AS ocorrencias
FROM gold.fact_job_posting f
JOIN gold.dim_fraud_reason r ON f.fraud_reason_srk = r.fraud_reason_sk
WHERE f.is_fake = TRUE
GROUP BY r.fraud_reason
ORDER BY ocorrencias DESC;


-- ============================================================================
-- 9. fraude × remoto
-- ==================================================
SELECT
    remote,
    COUNT(*) AS total_vagas,
    SUM(CASE WHEN is_fake THEN 1 ELSE 0 END) AS vagas_falsas,
    ROUND(100.0 * SUM(CASE WHEN is_fake THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_fraude
FROM gold.fact_job_posting
GROUP BY remote;

-- ============================================================================
-- 10. Salário médio: remoto vs presencial
-- ==================================================

SELECT
    remote,
    ROUND(AVG(salary_avg), 2) AS salario_medio
FROM gold.fact_job_posting
WHERE salary_avg IS NOT NULL
GROUP BY remote;


