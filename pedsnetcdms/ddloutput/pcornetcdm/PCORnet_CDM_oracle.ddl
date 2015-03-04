-- running migrations for 'PCORnet CDM'

/

CREATE TABLE alembic_version (
    version_num VARCHAR2(32 CHAR) NOT NULL
)

/

-- Running upgrade  -> 1f1e9d3f7891

CREATE TABLE diagnosis (
    raw_dx VARCHAR2(1028 CHAR), 
    pdx VARCHAR2(2 CHAR), 
    raw_dx_source VARCHAR2(1028 CHAR), 
    encounterid VARCHAR2(1028 CHAR) NOT NULL, 
    dx_type VARCHAR2(2 CHAR) NOT NULL, 
    enc_type VARCHAR2(2 CHAR), 
    raw_pdx VARCHAR2(1028 CHAR), 
    providerid VARCHAR2(1028 CHAR), 
    raw_dx_type VARCHAR2(1028 CHAR), 
    admit_date VARCHAR2(10 CHAR), 
    patid VARCHAR2(1028 CHAR) NOT NULL, 
    dx VARCHAR2(18 CHAR) NOT NULL, 
    dx_source VARCHAR2(2 CHAR), 
    CONSTRAINT pk_diagnosis PRIMARY KEY (patid, encounterid, dx, dx_type) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_diagnosis_patid_enc_fbc1 ON diagnosis (patid, encounterid, dx, dx_type)

/

CREATE TABLE vital (
    vitalid NUMBER(10) NOT NULL, 
    original_bmi NUMBER, 
    measure_date VARCHAR2(10 CHAR), 
    measure_time VARCHAR2(5 CHAR), 
    encounterid VARCHAR2(1028 CHAR), 
    ht NUMBER, 
    raw_diastolic VARCHAR2(1028 CHAR), 
    wt NUMBER, 
    systolic NUMBER, 
    patid VARCHAR2(1028 CHAR), 
    bp_position VARCHAR2(2 CHAR), 
    raw_bp_position VARCHAR2(1028 CHAR), 
    vital_source VARCHAR2(2 CHAR), 
    raw_vital_source VARCHAR2(1028 CHAR), 
    raw_systolic VARCHAR2(1028 CHAR), 
    diastolic NUMBER, 
    CONSTRAINT pk_vital PRIMARY KEY (vitalid) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_vital_vitalid ON vital (vitalid)

/

CREATE TABLE procedure (
    px VARCHAR2(18 CHAR) NOT NULL, 
    encounterid VARCHAR2(1028 CHAR) NOT NULL, 
    enc_type VARCHAR2(2 CHAR), 
    providerid VARCHAR2(1028 CHAR), 
    admit_date VARCHAR2(10 CHAR), 
    patid VARCHAR2(1028 CHAR) NOT NULL, 
    raw_px_type VARCHAR2(1028 CHAR), 
    px_type VARCHAR2(2 CHAR) NOT NULL, 
    raw_px VARCHAR2(1028 CHAR), 
    CONSTRAINT pk_procedure PRIMARY KEY (patid, encounterid, px, px_type) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_procedure_patid_enc_431b ON procedure (patid, encounterid, px, px_type)

/

CREATE TABLE encounter (
    admitting_source VARCHAR2(2 CHAR), 
    discharge_disposition VARCHAR2(2 CHAR), 
    facilityid VARCHAR2(1028 CHAR), 
    raw_enc_type VARCHAR2(1028 CHAR), 
    discharge_date VARCHAR2(10 CHAR), 
    admit_time VARCHAR2(5 CHAR), 
    discharge_time VARCHAR2(5 CHAR), 
    encounterid VARCHAR2(1028 CHAR) NOT NULL, 
    raw_discharge_disposition VARCHAR2(1028 CHAR), 
    enc_type VARCHAR2(2 CHAR), 
    raw_discharge_status VARCHAR2(1028 CHAR), 
    drg VARCHAR2(3 CHAR), 
    providerid VARCHAR2(1028 CHAR), 
    admit_date VARCHAR2(10 CHAR), 
    patid VARCHAR2(1028 CHAR) NOT NULL, 
    drg_type VARCHAR2(2 CHAR), 
    raw_admitting_source VARCHAR2(1028 CHAR), 
    discharge_status VARCHAR2(2 CHAR), 
    facility_location VARCHAR2(3 CHAR), 
    raw_drg_type VARCHAR2(1028 CHAR), 
    CONSTRAINT pk_encounter PRIMARY KEY (patid, encounterid) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_encounter_patid_encounterid ON encounter (patid, encounterid)

/

CREATE TABLE demographic (
    raw_hispanic VARCHAR2(1028 CHAR), 
    raw_sex VARCHAR2(1028 CHAR), 
    raw_race VARCHAR2(1028 CHAR), 
    sex VARCHAR2(2 CHAR), 
    hispanic VARCHAR2(2 CHAR), 
    race VARCHAR2(2 CHAR), 
    patid VARCHAR2(1028 CHAR) NOT NULL, 
    birth_date VARCHAR2(10 CHAR), 
    biobank_flag VARCHAR2(1 CHAR), 
    birth_time VARCHAR2(5 CHAR), 
    CONSTRAINT pk_demographic PRIMARY KEY (patid) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_demographic_patid ON demographic (patid)

/

CREATE TABLE enrollment (
    chart VARCHAR2(1 CHAR), 
    enr_basis VARCHAR2(1 CHAR) NOT NULL, 
    patid VARCHAR2(1028 CHAR) NOT NULL, 
    enr_end_date VARCHAR2(10 CHAR), 
    enr_start_date VARCHAR2(10 CHAR) NOT NULL, 
    CONSTRAINT pk_enrollment PRIMARY KEY (patid, enr_start_date, enr_basis) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_enrollment_patid_en_ea99 ON enrollment (patid, enr_start_date, enr_basis)

/

INSERT INTO alembic_version (version_num) VALUES ('1f1e9d3f7891')

/

