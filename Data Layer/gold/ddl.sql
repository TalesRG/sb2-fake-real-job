create schema if not exists gold;
create table gold.dim_cmp (
                                  cmp_srk bigserial primary key,
                                  cmp_nam text not null unique
);
create table gold.dim_jtl (
                                    jtl_srk bigserial primary key,
                                    jtl text not null unique
);
create table gold.dim_loc (
                                   loc_srk bigserial primary key,
                                   cty text,
                                   ste text,
                                   unique (cty, ste)
);
create table gold.dim_frd (
                                       frd_srk bigserial primary key,
                                       frd text not null unique
);
CREATE TABLE gold.fact_jpt
(
    job_id  BIGINT PRIMARY KEY,

    cmp_srk BIGINT REFERENCES gold.dim_cmp (cmp_srk),
    jtl_srk BIGINT REFERENCES gold.dim_jtl (jtl_srk),
    loc_srk BIGINT REFERENCES gold.dim_loc (loc_srk),
    frd_srk BIGINT REFERENCES gold.dim_frd (frd_srk),

    avg     NUMERIC,
    rmt     BOOLEAN,
    is_fake BOOLEAN,

    etl_ct  TIMESTAMP NOT NULL DEFAULT now()
)

