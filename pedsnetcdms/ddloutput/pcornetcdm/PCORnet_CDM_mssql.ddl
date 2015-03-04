-- running migrations for 'PCORnet CDM';

GO

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

GO

-- Running upgrade  -> 1f1e9d3f7891

CREATE TABLE diagnosis (
    raw_dx VARCHAR(1028) NULL, 
    pdx VARCHAR(2) NULL, 
    raw_dx_source VARCHAR(1028) NULL, 
    encounterid VARCHAR(1028) NOT NULL, 
    dx_type VARCHAR(2) NOT NULL, 
    enc_type VARCHAR(2) NULL, 
    raw_pdx VARCHAR(1028) NULL, 
    providerid VARCHAR(1028) NULL, 
    raw_dx_type VARCHAR(1028) NULL, 
    admit_date VARCHAR(10) NULL, 
    patid VARCHAR(1028) NOT NULL, 
    dx VARCHAR(18) NOT NULL, 
    dx_source VARCHAR(2) NULL, 
    CONSTRAINT pk_diagnosis PRIMARY KEY (patid, encounterid, dx, dx_type)
);

GO

CREATE INDEX ix_diagnosis_patid_encounterid_dx_dx_type ON diagnosis (patid, encounterid, dx, dx_type);

GO

CREATE TABLE vital (
    vitalid INTEGER NOT NULL IDENTITY(1,1), 
    original_bmi NUMERIC(8, 2) NULL, 
    measure_date VARCHAR(10) NULL, 
    measure_time VARCHAR(5) NULL, 
    encounterid VARCHAR(1028) NULL, 
    ht NUMERIC(8, 2) NULL, 
    raw_diastolic VARCHAR(1028) NULL, 
    wt NUMERIC(8, 2) NULL, 
    systolic NUMERIC(4, 0) NULL, 
    patid VARCHAR(1028) NULL, 
    bp_position VARCHAR(2) NULL, 
    raw_bp_position VARCHAR(1028) NULL, 
    vital_source VARCHAR(2) NULL, 
    raw_vital_source VARCHAR(1028) NULL, 
    raw_systolic VARCHAR(1028) NULL, 
    diastolic NUMERIC(4, 0) NULL, 
    CONSTRAINT pk_vital PRIMARY KEY (vitalid)
);

GO

CREATE INDEX ix_vital_vitalid ON vital (vitalid);

GO

CREATE TABLE [procedure] (
    px VARCHAR(18) NOT NULL, 
    encounterid VARCHAR(1028) NOT NULL, 
    enc_type VARCHAR(2) NULL, 
    providerid VARCHAR(1028) NULL, 
    admit_date VARCHAR(10) NULL, 
    patid VARCHAR(1028) NOT NULL, 
    raw_px_type VARCHAR(1028) NULL, 
    px_type VARCHAR(2) NOT NULL, 
    raw_px VARCHAR(1028) NULL, 
    CONSTRAINT pk_procedure PRIMARY KEY (patid, encounterid, px, px_type)
);

GO

CREATE INDEX ix_procedure_patid_encounterid_px_px_type ON [procedure] (patid, encounterid, px, px_type);

GO

CREATE TABLE encounter (
    admitting_source VARCHAR(2) NULL, 
    discharge_disposition VARCHAR(2) NULL, 
    facilityid VARCHAR(1028) NULL, 
    raw_enc_type VARCHAR(1028) NULL, 
    discharge_date VARCHAR(10) NULL, 
    admit_time VARCHAR(5) NULL, 
    discharge_time VARCHAR(5) NULL, 
    encounterid VARCHAR(1028) NOT NULL, 
    raw_discharge_disposition VARCHAR(1028) NULL, 
    enc_type VARCHAR(2) NULL, 
    raw_discharge_status VARCHAR(1028) NULL, 
    drg VARCHAR(3) NULL, 
    providerid VARCHAR(1028) NULL, 
    admit_date VARCHAR(10) NULL, 
    patid VARCHAR(1028) NOT NULL, 
    drg_type VARCHAR(2) NULL, 
    raw_admitting_source VARCHAR(1028) NULL, 
    discharge_status VARCHAR(2) NULL, 
    facility_location VARCHAR(3) NULL, 
    raw_drg_type VARCHAR(1028) NULL, 
    CONSTRAINT pk_encounter PRIMARY KEY (patid, encounterid)
);

GO

CREATE INDEX ix_encounter_patid_encounterid ON encounter (patid, encounterid);

GO

CREATE TABLE demographic (
    raw_hispanic VARCHAR(1028) NULL, 
    raw_sex VARCHAR(1028) NULL, 
    raw_race VARCHAR(1028) NULL, 
    sex VARCHAR(2) NULL, 
    hispanic VARCHAR(2) NULL, 
    race VARCHAR(2) NULL, 
    patid VARCHAR(1028) NOT NULL, 
    birth_date VARCHAR(10) NULL, 
    biobank_flag VARCHAR(1) NULL, 
    birth_time VARCHAR(5) NULL, 
    CONSTRAINT pk_demographic PRIMARY KEY (patid)
);

GO

CREATE INDEX ix_demographic_patid ON demographic (patid);

GO

CREATE TABLE enrollment (
    chart VARCHAR(1) NULL, 
    enr_basis VARCHAR(1) NOT NULL, 
    patid VARCHAR(1028) NOT NULL, 
    enr_end_date VARCHAR(10) NULL, 
    enr_start_date VARCHAR(10) NOT NULL, 
    CONSTRAINT pk_enrollment PRIMARY KEY (patid, enr_start_date, enr_basis)
);

GO

CREATE INDEX ix_enrollment_patid_enr_start_date_enr_basis ON enrollment (patid, enr_start_date, enr_basis);

GO

INSERT INTO alembic_version (version_num) VALUES ('1f1e9d3f7891');

GO

