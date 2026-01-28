# Dicionário de Mnemônicos – Gold Layer

Este documento define todas as abreviações e convenções de nomenclatura utilizadas no **Star Schema da camada Gold** do projeto **Fake–Real-Job**.

---

## 1. Abreviações de Tabelas

| Abreviação | Significado | Tabela Completa |
|------------|-------------|-----------------|
| `cmp`      | **C**o**mp**any (Empresa) | `dim_cmp`       |
| `jtl`      | **Job** Title (Cargo) | `dim_jtl`       |
| `loc`      | **Loc**ation (Localização) | `dim_loc`       |
| `frd`      | **Fr**au**d** (Motivo de fraude) | `dim_frd`       |
| `jpt`      | **P**o**st**ing (Publicação de vaga) | `fact_jpt`      |

---

## 2. Prefixos de Tabelas

| Prefixo | Significado | Exemplo                                    |
|---------|-------------|--------------------------------------------|
| `dim_`  | **Dim**ensão (tabela dimensional) | `dim_cmp`, `dim_jtl` , `dim_loc`,`dim_frd` |
| `fact_` | **Fact** (tabela fato) | `fact_jpt`                                 |

---

## 3. Sufixos de Chaves

| Sufixo | Significado | Uso           |
|--------|------------|---------------|
| `_srk` | **S**urrogate **R**eference **K**ey | Usado como PK |

### Exemplos

- `cmp_sk` – Chave primária da dimensão `dim_cmp`
- `cmp_srk` – Chave estrangeira na `fact_jpt` que referencia `dim_cmp(cmp_srk)`


## 4. Abreviações de Colunas

| Abreviação | Significado     | Uso                |
|------------|-----------------|--------------------|
| `avg`      | Average (Média) | `salary_avg`       |
| `is`       | Booleano        | Booleanos em EN    |
| `rmt`      | Booleano        | Booleanos em EN    |
| `etl_ct`   | Data            | Campos temporais   |

---

## 5. Estrutura das Tabelas

### 5.1 Dimensão Empresa (`dim_company`)

| Coluna    | Tipo | Descrição |
|-----------|-----|-----------|
| `cmp_srk` | BIGSERIAL | Chave primária surrogate |
| `cmp_nam` | TEXT | Nome da empresa contratante |

---

### 5.2 Dimensão Cargo (`dim_job_title`)

| Coluna    | Tipo | Descrição |
|-----------|-----|-----------|
| `jtl_srk` | BIGSERIAL | Chave primária surrogate |
| `jtl`     | TEXT | Título do cargo |

---

### 5.3 Dimensão Localização (`dim_location`)

| Coluna    | Tipo | Descrição |
|-----------|-----|-----------|
| `loc_srk` | BIGSERIAL | Chave primária surrogate |
| `cty`     | TEXT | País da vaga |
| `ste`     | TEXT | Estado ou região |

---

### 5.4 Dimensão Motivo de Fraude (`dim_fraud_reason`)

| Coluna    | Tipo | Descrição |
|-----------|-----|-----------|
| `frd_srk` | BIGSERIAL | Chave primária surrogate |
| `frd`     | TEXT | Motivo associado à fraude |

---

### 5.5 Fato Publicação de Vagas (`fact_job_posting`)
| Coluna    | Tipo      | Descrição                                |
|-----------| --------- |------------------------------------------|
| `job_id`  | BIGINT    | Identificador natural da vaga            |
| `cmp_srk` | BIGINT    | FK → `dim_company(company_sk)`           |
| `jtl_srk` | BIGINT    | FK → `dim_job_title(job_title_sk)`       |
| `loc_srk` | BIGINT    | FK → `dim_location(location_sk)`         |
| `frd_srk` | BIGINT    | FK → `dim_fraud_reason(fraud_reason_sk)` |
| `avg`     | NUMERIC   | Salário médio                            |
| `rmt`     | BOOLEAN   | Vaga remota                              |
| `is_fake` | BOOLEAN   | Indicador de fraude                      |
| `etl_ct`  | TIMESTAMP | Data da carga                            |

---

## 7. Convenções Gerais

1. snake_case
2. Dimensões usam _srk
3. Fato usa _srk
4. Star Schema

---

## 8. Diagrama do Star Schema

```
                        +------------------------+
                        |      dim_cmp           |
                        +------------------------+
                        | cmp_srk (PK)           |
                        | cpm_nam                |
                        +-----------+------------+
                                    |
                                    | cmp_srk (FK)
                                    v
+------------------------+   +-----------------------------+   +------------------------+
|    dim_jtl             |   |     fact_jpt                |   |     dim_loc            |
+------------------------+   +-----------------------------+   +------------------------+
| jtl_srk (PK)           |<--| jtl_srk (FK)                |   | loc_srk (PK)           |
| jtl                    |   | cmp_srk (FK)                |-->| cty                    |
+------------------------+   | loc_srk (FK)                |   | ste                    |
                             | frd_srk (FK)                |   +------------------------+
                             | avg                         |
                             | rmt                         |
                             | is_fake                     |
                             | etl_ct                      |
                             +-------------+---------------+
                                           |
                                           v
                             +-------------------------------+
                             |     dim_frd                   |
                             +-------------------------------+
                             | frd_srk (PK)                  |
                             | frd                           |
                             +-------------------------------+
    

```

---

*Documento gerado para o projeto Fake–Real Job – ETL Silver to Gold.*
