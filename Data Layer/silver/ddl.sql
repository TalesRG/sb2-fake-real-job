create table silver_jobs
(
    job_id                         integer,
    job_title                      text,
    company_name                   text,
    location                       text,
    industry                       text,
    employment_type                text,
    required_experience_years      integer,
    telecommuting                  boolean,
    has_logo                       boolean,
    is_fake                        boolean,
    posting_timestamp              timestamp,
    application_deadline_timestamp timestamp,
    salary_range                   text,
    salary_clean                   text,
    salary_min                     integer,
    salary_max                     integer,
    salary_avg                     integer
);

alter table silver_jobs
    owner to postgres;

