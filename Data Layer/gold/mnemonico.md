# Dicionário de Mnemônicos – Gold Layer

Este documento define todas as abreviações e convenções de nomenclatura utilizadas no **Star Schema da camada Gold** do projeto **Fake–Real Job ETL**.

---

## 1. Abreviações de Tabelas

| Abreviação | Significado | Tabela Completa |
|------------|-------------|-----------------|
| `cmp` | **C**o**mp**any (Empresa) | `dim_company` |
| `job` | **Job** Title (Cargo) | `dim_job_title` |
| `loc` | **Loc**ation (Localização) | `dim_location` |
| `frd` | **Fr**au**d** (Motivo de fraude) | `dim_fraud_reason` |
| `pst` | **P**o**st**ing (Publicação de vaga) | `fact_job_posting` |

---

## 2. Prefixos de Tabelas

| Prefixo | Significado | Exemplo |
|--------|-------------|--------|
| `dim_` | **Dim**ensão (tabela dimensional) | `dim_company`, `dim_job_title` |
| `fact_` | **Fact** (tabela fato) | `fact_job_posting` |
| `vw_` | **V**ie**w** (visão analítica) | `vw_salary_by_location` |
| `idx_` | **Idx** (índice) | `idx_fact_company` |

---

## 3. Sufixos de Chaves

| Sufixo | Significado | Uso |
|--------|------------|-----|
| `_key` | **Key** – Chave primária surrogate | Usado nas tabelas de dimensão |
| `_srk` | **S**urrogate **R**eference **K**ey | Usado na tabela fato como FK |

### Exemplos

- `company_key` – Chave primária da dimensão `dim_company`
- `company_srk` – Chave estrangeira na `fact_job_posting` que referencia `dim_company(company_key)`


## 4. Abreviações de Colunas

| Abreviação | Significado | Uso |
|-----------|------------|-----|
| `dt` | Data | Campos temporais |
| `nr` | Número | Identificadores |
| `vlr` | Valor | Valores monetários |
| `avg` | Average (Média) | `salary_avg` |
| `min` | Minimum | `salary_min` |
| `max` | Maximum | `salary_max` |
| `eh` | Verbo ser | Booleanos em PT |
| `is` | Booleano | Booleanos em EN |

---

## 5. Estrutura das Tabelas

### 5.1 Dimensão Empresa (`dim_company`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `company_sk` | BIGSERIAL | Chave primária surrogate |
| `company_name` | TEXT | Nome da empresa contratante |

---

### 5.2 Dimensão Cargo (`dim_job_title`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `job_title_sk` | BIGSERIAL | Chave primária surrogate |
| `job_title` | TEXT | Título do cargo |

---

### 5.3 Dimensão Localização (`dim_location`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `location_sk` | BIGSERIAL | Chave primária surrogate |
| `country` | TEXT | País da vaga |
| `state` | TEXT | Estado ou região |

---

### 5.4 Dimensão Motivo de Fraude (`dim_fraud_reason`)

| Coluna | Tipo | Descrição |
|------|-----|-----------|
| `fraud_reason_sk` | BIGSERIAL | Chave primária surrogate |
| `fraud_reason` | TEXT | Motivo associado à fraude |

---

### 5.5 Fato Publicação de Vagas (`fact_job_posting`)
| Coluna             | Tipo      | Descrição                                 |
| ------------------ | --------- | ----------------------------------------- |
| `job_id`           | BIGINT    | Identificador natural da vaga             |
| `company_srk`      | BIGINT    | FK → `dim_company(company_key)`           |
| `job_title_srk`    | BIGINT    | FK → `dim_job_title(job_title_key)`       |
| `location_srk`     | BIGINT    | FK → `dim_location(location_key)`         |
| `fraud_reason_srk` | BIGINT    | FK → `dim_fraud_reason(fraud_reason_key)` |
| `salary_avg`       | NUMERIC   | Salário médio                             |
| `remote`           | BOOLEAN   | Vaga remota                               |
| `is_fake`          | BOOLEAN   | Indicador de fraude                       |
| `etl_loaded_at`    | TIMESTAMP | Data da carga                             |

---

## 7. Convenções Gerais

1. snake_case
2. Dimensões usam _key
3. Fato usa _srk
4. Star Schema puro
5. Sem redundância analítica
6. Apenas atributos usados em análise
7. Modelo alinhado ao ETL implementado

---

## 8. Diagrama do Star Schema

```
                        +------------------------+
                        |      dim_company       |
                        +------------------------+
                        | company_key (PK)       |
                        | company_name           |
                        +-----------+------------+
                                    |
                                    | company_srk
                                    v
+------------------------+   +-----------------------------+   +------------------------+
|    dim_job_title       |   |     fact_job_posting        |   |     dim_location       |
+------------------------+   +-----------------------------+   +------------------------+
| job_title_key (PK)     |<--| job_title_srk (FK)          |   | location_key (PK)      |
| job_title              |   | company_srk (FK)            |-->| country                |
+------------------------+   | location_srk (FK)           |   | state                  |
                             | fraud_reason_srk (FK)       |   +------------------------+
                             | salary_avg                  |
                             | remote                      |
                             | is_fake                     |
                             +-------------+---------------+
                                           |
                                           v
                             +-------------------------------+
                             |     dim_fraud_reason          |
                             +-------------------------------+
                             | fraud_reason_key (PK)         |
                             | fraud_reason                  |
                             +-------------------------------+
    

```

---

*Documento gerado para o projeto Fake–Real Job – ETL Silver to Gold.*
