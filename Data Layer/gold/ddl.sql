create schema if not exists gold;
create table gold.dim_company (
                                       company_sk bigserial primary key,
                                       company_name text not null unique
                                     );
create table gold.dim_job_title (
                                       job_title_sk bigserial primary key,
                                       job_title text not null unique
                                     );
create table gold.dim_location (
                                       location_sk bigserial primary key,
                                       country text,
                                       state text,
                                       unique (country, state)
                                     );
create table gold.dim_fraud_reason (
                                       fraud_reason_sk bigserial primary key,
                                       fraud_reason text not null unique
                                     );
CREATE TABLE gold.fact_job_posting (
    job_id BIGINT PRIMARY KEY,

    company_srk BIGINT REFERENCES gold.dim_company(company_sk),
    job_title_srk BIGINT REFERENCES gold.dim_job_title(job_title_sk),
    location_srk BIGINT REFERENCES gold.dim_location(location_sk),
    fraud_reason_srk BIGINT REFERENCES gold.dim_fraud_reason(fraud_reason_sk),

    salary_avg NUMERIC,
    remote BOOLEAN,
    is_fake BOOLEAN,

    etl_loaded_at TIMESTAMP NOT NULL DEFAULT now()
