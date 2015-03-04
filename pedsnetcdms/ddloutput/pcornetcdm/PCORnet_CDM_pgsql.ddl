-- running migrations for 'PCORnet CDM';

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

-- Running upgrade  -> 1f1e9d3f7891

CREATE TABLE diagnosis (
    raw_dx VARCHAR(1028), 
    pdx VARCHAR(2), 
    raw_dx_source VARCHAR(1028), 
    encounterid VARCHAR(1028) NOT NULL, 
    dx_type VARCHAR(2) NOT NULL, 
    enc_type VARCHAR(2), 
    raw_pdx VARCHAR(1028), 
    providerid VARCHAR(1028), 
    raw_dx_type VARCHAR(1028), 
    admit_date VARCHAR(10), 
    patid VARCHAR(1028) NOT NULL, 
    dx VARCHAR(18) NOT NULL, 
    dx_source VARCHAR(2), 
    CONSTRAINT pk_diagnosis PRIMARY KEY (patid, encounterid, dx, dx_type) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_diagnosis_patid_encounterid_dx_dx_type ON diagnosis (patid varchar_pattern_ops, encounterid varchar_pattern_ops, dx varchar_pattern_ops, dx_type varchar_pattern_ops);

CREATE TABLE vital (
    vitalid SERIAL NOT NULL, 
    original_bmi NUMERIC(8, 2), 
    measure_date VARCHAR(10), 
    measure_time VARCHAR(5), 
    encounterid VARCHAR(1028), 
    ht NUMERIC(8, 2), 
    raw_diastolic VARCHAR(1028), 
    wt NUMERIC(8, 2), 
    systolic NUMERIC(4, 0), 
    patid VARCHAR(1028), 
    bp_position VARCHAR(2), 
    raw_bp_position VARCHAR(1028), 
    vital_source VARCHAR(2), 
    raw_vital_source VARCHAR(1028), 
    raw_systolic VARCHAR(1028), 
    diastolic NUMERIC(4, 0), 
    CONSTRAINT pk_vital PRIMARY KEY (vitalid) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_vital_vitalid ON vital (vitalid);

CREATE TABLE procedure (
    px VARCHAR(18) NOT NULL, 
    encounterid VARCHAR(1028) NOT NULL, 
    enc_type VARCHAR(2), 
    providerid VARCHAR(1028), 
    admit_date VARCHAR(10), 
    patid VARCHAR(1028) NOT NULL, 
    raw_px_type VARCHAR(1028), 
    px_type VARCHAR(2) NOT NULL, 
    raw_px VARCHAR(1028), 
    CONSTRAINT pk_procedure PRIMARY KEY (patid, encounterid, px, px_type) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_procedure_patid_encounterid_px_px_type ON procedure (patid varchar_pattern_ops, encounterid varchar_pattern_ops, px varchar_pattern_ops, px_type varchar_pattern_ops);

CREATE TABLE encounter (
    admitting_source VARCHAR(2), 
    discharge_disposition VARCHAR(2), 
    facilityid VARCHAR(1028), 
    raw_enc_type VARCHAR(1028), 
    discharge_date VARCHAR(10), 
    admit_time VARCHAR(5), 
    discharge_time VARCHAR(5), 
    encounterid VARCHAR(1028) NOT NULL, 
    raw_discharge_disposition VARCHAR(1028), 
    enc_type VARCHAR(2), 
    raw_discharge_status VARCHAR(1028), 
    drg VARCHAR(3), 
    providerid VARCHAR(1028), 
    admit_date VARCHAR(10), 
    patid VARCHAR(1028) NOT NULL, 
    drg_type VARCHAR(2), 
    raw_admitting_source VARCHAR(1028), 
    discharge_status VARCHAR(2), 
    facility_location VARCHAR(3), 
    raw_drg_type VARCHAR(1028), 
    CONSTRAINT pk_encounter PRIMARY KEY (patid, encounterid) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_encounter_patid_encounterid ON encounter (patid varchar_pattern_ops, encounterid varchar_pattern_ops);

CREATE TABLE demographic (
    raw_hispanic VARCHAR(1028), 
    raw_sex VARCHAR(1028), 
    raw_race VARCHAR(1028), 
    sex VARCHAR(2), 
    hispanic VARCHAR(2), 
    race VARCHAR(2), 
    patid VARCHAR(1028) NOT NULL, 
    birth_date VARCHAR(10), 
    biobank_flag VARCHAR(1), 
    birth_time VARCHAR(5), 
    CONSTRAINT pk_demographic PRIMARY KEY (patid) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_demographic_patid ON demographic (patid varchar_pattern_ops);

CREATE TABLE enrollment (
    chart VARCHAR(1), 
    enr_basis VARCHAR(1) NOT NULL, 
    patid VARCHAR(1028) NOT NULL, 
    enr_end_date VARCHAR(10), 
    enr_start_date VARCHAR(10) NOT NULL, 
    CONSTRAINT pk_enrollment PRIMARY KEY (patid, enr_start_date, enr_basis) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_enrollment_patid_enr_start_date_enr_basis ON enrollment (patid varchar_pattern_ops, enr_start_date varchar_pattern_ops, enr_basis varchar_pattern_ops);

INSERT INTO alembic_version (version_num) VALUES ('1f1e9d3f7891');

