-- running migrations for 'I2B2 CDM';

GO

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

GO

-- Running upgrade  -> 1a2b15a3ecfc

CREATE TABLE observation_fact (
    provider_id VARCHAR(50) NOT NULL, 
    nval_num NUMERIC(18, 5) NULL, 
    confidence_num NUMERIC(18, 5) NULL, 
    encounter_num NUMERIC(38, 0) NOT NULL, 
    update_date DATETIME NULL, 
    download_date DATETIME NULL, 
    import_date DATETIME NULL, 
    valueflag_cd VARCHAR(50) NULL, 
    tval_char VARCHAR(255) NULL, 
    modifier_cd VARCHAR(100) NOT NULL, 
    start_date DATETIME NOT NULL, 
    patient_num NUMERIC(38, 0) NOT NULL, 
    end_date DATETIME NULL, 
    instance_num NUMERIC(18, 0) NOT NULL DEFAULT '1', 
    sourcesystem_cd VARCHAR(50) NULL, 
    concept_cd VARCHAR(50) NOT NULL, 
    observation_blob TEXT NULL, 
    upload_id NUMERIC(38, 0) NULL, 
    quantity_num NUMERIC(18, 5) NULL, 
    valtype_cd VARCHAR(50) NULL, 
    units_cd VARCHAR(50) NULL, 
    location_cd VARCHAR(50) NULL, 
    CONSTRAINT pk_observation_fact PRIMARY KEY (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id)
);

GO

CREATE INDEX ix_observation_fact_concept_cd ON observation_fact (concept_cd);

GO

CREATE INDEX ix_observation_fact_concept_cd_instance_num_patient_num_encounter_num ON observation_fact (concept_cd, instance_num, patient_num, encounter_num);

GO

CREATE INDEX ix_observation_fact_encounter_num ON observation_fact (encounter_num);

GO

CREATE INDEX ix_observation_fact_patient_num_concept_cd_modifier_cd_start_date_encounter_num_instance_num_provider_id ON observation_fact (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id);

GO

CREATE INDEX ix_observation_fact_patient_num_concept_cd_start_date_end_date_encounter_num_instance_num_provider_id_nval_num_valtype_cd ON observation_fact (patient_num, concept_cd, start_date, end_date, encounter_num, instance_num, provider_id, nval_num, valtype_cd);

GO

CREATE INDEX ix_observation_fact_patient_num_start_date_concept_cd_encounter_num_instance_num_nval_num_tval_char_valtype_cd_modifier__8e58 ON observation_fact (patient_num, start_date, concept_cd, encounter_num, instance_num, nval_num, tval_char, valtype_cd, modifier_cd, valueflag_cd, provider_id, quantity_num, units_cd, end_date, location_cd, confidence_num, update_date, download_date, import_date, sourcesystem_cd, upload_id);

GO

CREATE TABLE concept_dimension (
    concept_cd VARCHAR(50) NOT NULL, 
    update_date DATETIME NULL, 
    concept_blob TEXT NULL, 
    download_date DATETIME NULL, 
    name_char VARCHAR(2000) NULL, 
    concept_path VARCHAR(700) NOT NULL, 
    import_date DATETIME NULL, 
    upload_id NUMERIC(38, 0) NULL, 
    sourcesystem_cd VARCHAR(50) NULL, 
    CONSTRAINT pk_concept_dimension PRIMARY KEY (concept_path)
);

GO

CREATE INDEX ix_concept_dimension_concept_path ON concept_dimension (concept_path);

GO

CREATE INDEX ix_concept_dimension_upload_id ON concept_dimension (upload_id);

GO

CREATE TABLE patient_dimension (
    update_date DATETIME NULL, 
    zip_cd VARCHAR(50) NULL, 
    race_cd VARCHAR(50) NULL, 
    download_date DATETIME NULL, 
    death_date DATETIME NULL, 
    marital_status_cd VARCHAR(50) NULL, 
    import_date DATETIME NULL, 
    patient_blob TEXT NULL, 
    vital_status_cd VARCHAR(50) NULL, 
    income_cd VARCHAR(50) NULL, 
    religion_cd VARCHAR(50) NULL, 
    sex_cd VARCHAR(50) NULL, 
    patient_num NUMERIC(38, 0) NOT NULL, 
    age_in_years_num NUMERIC(38, 0) NULL, 
    birth_date DATETIME NULL, 
    upload_id NUMERIC(38, 0) NULL, 
    statecityzip_path VARCHAR(50) NULL, 
    language_cd VARCHAR(50) NULL, 
    ethnicity_cd VARCHAR(50) NULL, 
    sourcesystem_cd VARCHAR(50) NULL, 
    CONSTRAINT pk_patient_dimension PRIMARY KEY (patient_num)
);

GO

CREATE INDEX ix_patient_dimension_patient_num ON patient_dimension (patient_num);

GO

CREATE INDEX ix_patient_dimension_patient_num_vital_status_cd_birth_date_death_date ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date);

GO

CREATE INDEX ix_patient_dimension_patient_num_vital_status_cd_birth_date_death_date_sex_cd_age_in_years_num_language_cd_race_cd_marit_3ed3 ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date, sex_cd, age_in_years_num, language_cd, race_cd, marital_status_cd, religion_cd, zip_cd, income_cd);

GO

CREATE INDEX ix_patient_dimension_statecityzip_path_patient_num ON patient_dimension (statecityzip_path, patient_num);

GO

CREATE INDEX ix_patient_dimension_upload_id ON patient_dimension (upload_id);

GO

CREATE TABLE i2b2 (
    c_columndatatype VARCHAR(50) NOT NULL, 
    c_dimcode VARCHAR(700) NOT NULL, 
    c_name VARCHAR(2000) NOT NULL, 
    c_facttablecolumn VARCHAR(50) NOT NULL, 
    c_basecode VARCHAR(50) NULL, 
    c_fullname VARCHAR(700) NOT NULL, 
    c_tablename VARCHAR(50) NOT NULL, 
    id INTEGER NOT NULL IDENTITY(1,1), 
    update_date DATETIME NOT NULL, 
    m_exclusion_cd VARCHAR(25) NULL, 
    c_synonym_cd VARCHAR(1) NOT NULL, 
    valuetype_cd VARCHAR(50) NULL, 
    import_date DATETIME NULL, 
    c_visualattributes VARCHAR(3) NOT NULL, 
    c_symbol VARCHAR(50) NULL, 
    m_applied_path VARCHAR(700) NOT NULL, 
    download_date DATETIME NULL, 
    c_operator VARCHAR(10) NOT NULL, 
    sourcesystem_cd VARCHAR(50) NULL, 
    c_hlevel NUMERIC(22, 0) NOT NULL, 
    c_columnname VARCHAR(50) NOT NULL, 
    c_totalnum NUMERIC(22, 0) NULL, 
    c_metadataxml TEXT NULL, 
    c_tooltip VARCHAR(900) NULL, 
    c_comment TEXT NULL, 
    c_path VARCHAR(700) NULL, 
    CONSTRAINT pk_i2b2 PRIMARY KEY (id)
);

GO

CREATE INDEX ix_i2b2_id ON i2b2 (id);

GO

CREATE TABLE visit_dimension (
    update_date DATETIME NULL, 
    download_date DATETIME NULL, 
    end_date DATETIME NULL, 
    active_status_cd VARCHAR(50) NULL, 
    import_date DATETIME NULL, 
    upload_id NUMERIC(38, 0) NULL, 
    patient_num NUMERIC(38, 0) NOT NULL, 
    sourcesystem_cd VARCHAR(50) NULL, 
    inout_cd VARCHAR(50) NULL, 
    location_path VARCHAR(900) NULL, 
    length_of_stay NUMERIC(38, 0) NULL, 
    visit_blob TEXT NULL, 
    start_date DATETIME NULL, 
    location_cd VARCHAR(50) NULL, 
    encounter_num NUMERIC(38, 0) NOT NULL, 
    CONSTRAINT pk_visit_dimension PRIMARY KEY (encounter_num, patient_num)
);

GO

CREATE INDEX ix_visit_dimension_encounter_num ON visit_dimension (encounter_num);

GO

CREATE INDEX ix_visit_dimension_encounter_num_patient_num ON visit_dimension (encounter_num, patient_num);

GO

CREATE INDEX ix_visit_dimension_encounter_num_patient_num_location_path_inout_cd_start_date_end_date_length_of_stay ON visit_dimension (encounter_num, patient_num, location_path, inout_cd, start_date, end_date, length_of_stay);

GO

CREATE INDEX ix_visit_dimension_sourcesystem_cd ON visit_dimension (sourcesystem_cd);

GO

CREATE INDEX ix_visit_dimension_start_date_end_date ON visit_dimension (start_date, end_date);

GO

CREATE INDEX ix_visit_dimension_upload_id ON visit_dimension (upload_id);

GO

INSERT INTO alembic_version (version_num) VALUES ('1a2b15a3ecfc');

GO

