-- running migrations for 'I2B2 CDM';

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

-- Running upgrade  -> 1a2b15a3ecfc

CREATE TABLE observation_fact (
    provider_id VARCHAR(50) NOT NULL, 
    nval_num NUMERIC(18, 5), 
    confidence_num NUMERIC(18, 5), 
    encounter_num NUMERIC(38, 0) NOT NULL, 
    update_date DATETIME, 
    download_date DATETIME, 
    import_date DATETIME, 
    valueflag_cd VARCHAR(50), 
    tval_char VARCHAR(255), 
    modifier_cd VARCHAR(100) NOT NULL, 
    start_date DATETIME NOT NULL, 
    patient_num NUMERIC(38, 0) NOT NULL, 
    end_date DATETIME, 
    instance_num NUMERIC(18, 0) DEFAULT '1' NOT NULL, 
    sourcesystem_cd VARCHAR(50), 
    concept_cd VARCHAR(50) NOT NULL, 
    observation_blob TEXT, 
    upload_id NUMERIC(38, 0), 
    quantity_num NUMERIC(18, 5), 
    valtype_cd VARCHAR(50), 
    units_cd VARCHAR(50), 
    location_cd VARCHAR(50), 
    CONSTRAINT pk_observation_fact PRIMARY KEY (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id)
);

CREATE INDEX ix_observation_fact_concept_cd ON observation_fact (concept_cd);

CREATE INDEX ix_observation_fact_concept_cd_instance_num_patient_num__f90e ON observation_fact (concept_cd, instance_num, patient_num, encounter_num);

CREATE INDEX ix_observation_fact_encounter_num ON observation_fact (encounter_num);

CREATE INDEX ix_observation_fact_patient_num_concept_cd_modifier_cd_s_b1cd ON observation_fact (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id);

CREATE INDEX ix_observation_fact_patient_num_concept_cd_start_date_en_e830 ON observation_fact (patient_num, concept_cd, start_date, end_date, encounter_num, instance_num, provider_id, nval_num, valtype_cd);

CREATE INDEX ix_observation_fact_patient_num_start_date_concept_cd_en_8e58 ON observation_fact (patient_num, start_date, concept_cd, encounter_num, instance_num, nval_num, tval_char, valtype_cd, modifier_cd, valueflag_cd, provider_id, quantity_num, units_cd, end_date, location_cd, confidence_num, update_date, download_date, import_date, sourcesystem_cd, upload_id);

CREATE TABLE concept_dimension (
    concept_cd VARCHAR(50) NOT NULL, 
    update_date DATETIME, 
    concept_blob TEXT, 
    download_date DATETIME, 
    name_char VARCHAR(2000), 
    concept_path VARCHAR(700) NOT NULL, 
    import_date DATETIME, 
    upload_id NUMERIC(38, 0), 
    sourcesystem_cd VARCHAR(50), 
    CONSTRAINT pk_concept_dimension PRIMARY KEY (concept_path)
);

CREATE INDEX ix_concept_dimension_concept_path ON concept_dimension (concept_path);

CREATE INDEX ix_concept_dimension_upload_id ON concept_dimension (upload_id);

CREATE TABLE patient_dimension (
    update_date DATETIME, 
    zip_cd VARCHAR(50), 
    race_cd VARCHAR(50), 
    download_date DATETIME, 
    death_date DATETIME, 
    marital_status_cd VARCHAR(50), 
    import_date DATETIME, 
    patient_blob TEXT, 
    vital_status_cd VARCHAR(50), 
    income_cd VARCHAR(50), 
    religion_cd VARCHAR(50), 
    sex_cd VARCHAR(50), 
    patient_num NUMERIC(38, 0) NOT NULL, 
    age_in_years_num NUMERIC(38, 0), 
    birth_date DATETIME, 
    upload_id NUMERIC(38, 0), 
    statecityzip_path VARCHAR(50), 
    language_cd VARCHAR(50), 
    ethnicity_cd VARCHAR(50), 
    sourcesystem_cd VARCHAR(50), 
    CONSTRAINT pk_patient_dimension PRIMARY KEY (patient_num)
);

CREATE INDEX ix_patient_dimension_patient_num ON patient_dimension (patient_num);

CREATE INDEX ix_patient_dimension_patient_num_vital_status_cd_birth_d_0f03 ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date);

CREATE INDEX ix_patient_dimension_patient_num_vital_status_cd_birth_d_3ed3 ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date, sex_cd, age_in_years_num, language_cd, race_cd, marital_status_cd, religion_cd, zip_cd, income_cd);

CREATE INDEX ix_patient_dimension_statecityzip_path_patient_num ON patient_dimension (statecityzip_path, patient_num);

CREATE INDEX ix_patient_dimension_upload_id ON patient_dimension (upload_id);

CREATE TABLE i2b2 (
    c_columndatatype VARCHAR(50) NOT NULL, 
    c_dimcode VARCHAR(700) NOT NULL, 
    c_name VARCHAR(2000) NOT NULL, 
    c_facttablecolumn VARCHAR(50) NOT NULL, 
    c_basecode VARCHAR(50), 
    c_fullname VARCHAR(700) NOT NULL, 
    c_tablename VARCHAR(50) NOT NULL, 
    id INTEGER NOT NULL AUTO_INCREMENT, 
    update_date DATETIME NOT NULL, 
    m_exclusion_cd VARCHAR(25), 
    c_synonym_cd VARCHAR(1) NOT NULL, 
    valuetype_cd VARCHAR(50), 
    import_date DATETIME, 
    c_visualattributes VARCHAR(3) NOT NULL, 
    c_symbol VARCHAR(50), 
    m_applied_path VARCHAR(700) NOT NULL, 
    download_date DATETIME, 
    c_operator VARCHAR(10) NOT NULL, 
    sourcesystem_cd VARCHAR(50), 
    c_hlevel NUMERIC(22, 0) NOT NULL, 
    c_columnname VARCHAR(50) NOT NULL, 
    c_totalnum NUMERIC(22, 0), 
    c_metadataxml TEXT, 
    c_tooltip VARCHAR(900), 
    c_comment TEXT, 
    c_path VARCHAR(700), 
    CONSTRAINT pk_i2b2 PRIMARY KEY (id)
);

CREATE INDEX ix_i2b2_id ON i2b2 (id);

CREATE TABLE visit_dimension (
    update_date DATETIME, 
    download_date DATETIME, 
    end_date DATETIME, 
    active_status_cd VARCHAR(50), 
    import_date DATETIME, 
    upload_id NUMERIC(38, 0), 
    patient_num NUMERIC(38, 0) NOT NULL, 
    sourcesystem_cd VARCHAR(50), 
    inout_cd VARCHAR(50), 
    location_path VARCHAR(900), 
    length_of_stay NUMERIC(38, 0), 
    visit_blob TEXT, 
    start_date DATETIME, 
    location_cd VARCHAR(50), 
    encounter_num NUMERIC(38, 0) NOT NULL, 
    CONSTRAINT pk_visit_dimension PRIMARY KEY (encounter_num, patient_num)
);

CREATE INDEX ix_visit_dimension_encounter_num ON visit_dimension (encounter_num);

CREATE INDEX ix_visit_dimension_encounter_num_patient_num ON visit_dimension (encounter_num, patient_num);

CREATE INDEX ix_visit_dimension_encounter_num_patient_num_location_pa_20cd ON visit_dimension (encounter_num, patient_num, location_path, inout_cd, start_date, end_date, length_of_stay);

CREATE INDEX ix_visit_dimension_sourcesystem_cd ON visit_dimension (sourcesystem_cd);

CREATE INDEX ix_visit_dimension_start_date_end_date ON visit_dimension (start_date, end_date);

CREATE INDEX ix_visit_dimension_upload_id ON visit_dimension (upload_id);

INSERT INTO alembic_version (version_num) VALUES ('1a2b15a3ecfc');

