CREATE TABLE silver_jobs (
    job_id                         INTEGER      NOT NULL,
    job_title                      TEXT         NOT NULL,
    company_name                   TEXT,
    location                       TEXT,
    industry                       TEXT,
    required_experience_years      INTEGER,
    is_fake                        BOOLEAN       NOT NULL,
    posting_timestamp              TIMESTAMP,
    application_deadline_timestamp TIMESTAMP,
    salary_range                   TEXT,
    salary_clean                   TEXT,
    salary_min                     INTEGER,
    salary_max                     INTEGER,
    salary_avg                     INTEGER,

    CONSTRAINT pk_silver_jobs PRIMARY KEY (job_id)
);
