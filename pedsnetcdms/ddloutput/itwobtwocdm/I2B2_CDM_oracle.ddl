-- running migrations for 'I2B2 CDM'

/

CREATE TABLE alembic_version (
    version_num VARCHAR2(32 CHAR) NOT NULL
)

/

-- Running upgrade  -> 1a2b15a3ecfc

CREATE TABLE observation_fact (
    provider_id VARCHAR2(50 CHAR) NOT NULL, 
    nval_num NUMBER, 
    confidence_num NUMBER, 
    encounter_num NUMBER NOT NULL, 
    update_date DATE, 
    download_date DATE, 
    import_date DATE, 
    valueflag_cd VARCHAR2(50 CHAR), 
    tval_char VARCHAR2(255 CHAR), 
    modifier_cd VARCHAR2(100 CHAR) NOT NULL, 
    start_date DATE NOT NULL, 
    patient_num NUMBER NOT NULL, 
    end_date DATE, 
    instance_num NUMBER DEFAULT '1' NOT NULL, 
    sourcesystem_cd VARCHAR2(50 CHAR), 
    concept_cd VARCHAR2(50 CHAR) NOT NULL, 
    observation_blob CLOB, 
    upload_id NUMBER, 
    quantity_num NUMBER, 
    valtype_cd VARCHAR2(50 CHAR), 
    units_cd VARCHAR2(50 CHAR), 
    location_cd VARCHAR2(50 CHAR), 
    CONSTRAINT pk_observation_fact PRIMARY KEY (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_observation_fact_concept_cd ON observation_fact (concept_cd)

/

CREATE INDEX ix_observation_fact_co_f90e ON observation_fact (concept_cd, instance_num, patient_num, encounter_num)

/

CREATE INDEX ix_observation_fact_en_7186 ON observation_fact (encounter_num)

/

CREATE INDEX ix_observation_fact_pa_b1cd ON observation_fact (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id)

/

CREATE INDEX ix_observation_fact_pa_e830 ON observation_fact (patient_num, concept_cd, start_date, end_date, encounter_num, instance_num, provider_id, nval_num, valtype_cd)

/

CREATE INDEX ix_observation_fact_pa_8e58 ON observation_fact (patient_num, start_date, concept_cd, encounter_num, instance_num, nval_num, tval_char, valtype_cd, modifier_cd, valueflag_cd, provider_id, quantity_num, units_cd, end_date, location_cd, confidence_num, update_date, download_date, import_date, sourcesystem_cd, upload_id)

/

CREATE TABLE concept_dimension (
    concept_cd VARCHAR2(50 CHAR) NOT NULL, 
    update_date DATE, 
    concept_blob CLOB, 
    download_date DATE, 
    name_char VARCHAR2(2000 CHAR), 
    concept_path VARCHAR2(700 CHAR) NOT NULL, 
    import_date DATE, 
    upload_id NUMBER, 
    sourcesystem_cd VARCHAR2(50 CHAR), 
    CONSTRAINT pk_concept_dimension PRIMARY KEY (concept_path) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_concept_dimension_c_3ad6 ON concept_dimension (concept_path)

/

CREATE INDEX ix_concept_dimension_upload_id ON concept_dimension (upload_id)

/

CREATE TABLE patient_dimension (
    update_date DATE, 
    zip_cd VARCHAR2(50 CHAR), 
    race_cd VARCHAR2(50 CHAR), 
    download_date DATE, 
    death_date DATE, 
    marital_status_cd VARCHAR2(50 CHAR), 
    import_date DATE, 
    patient_blob CLOB, 
    vital_status_cd VARCHAR2(50 CHAR), 
    income_cd VARCHAR2(50 CHAR), 
    religion_cd VARCHAR2(50 CHAR), 
    sex_cd VARCHAR2(50 CHAR), 
    patient_num NUMBER NOT NULL, 
    age_in_years_num NUMBER, 
    birth_date DATE, 
    upload_id NUMBER, 
    statecityzip_path VARCHAR2(50 CHAR), 
    language_cd VARCHAR2(50 CHAR), 
    ethnicity_cd VARCHAR2(50 CHAR), 
    sourcesystem_cd VARCHAR2(50 CHAR), 
    CONSTRAINT pk_patient_dimension PRIMARY KEY (patient_num) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_patient_dimension_p_5e8d ON patient_dimension (patient_num)

/

CREATE INDEX ix_patient_dimension_p_0f03 ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date)

/

CREATE INDEX ix_patient_dimension_p_3ed3 ON patient_dimension (patient_num, vital_status_cd, birth_date, death_date, sex_cd, age_in_years_num, language_cd, race_cd, marital_status_cd, religion_cd, zip_cd, income_cd)

/

CREATE INDEX ix_patient_dimension_s_6c54 ON patient_dimension (statecityzip_path, patient_num)

/

CREATE INDEX ix_patient_dimension_upload_id ON patient_dimension (upload_id)

/

CREATE TABLE i2b2 (
    c_columndatatype VARCHAR2(50 CHAR) NOT NULL, 
    c_dimcode VARCHAR2(700 CHAR) NOT NULL, 
    c_name VARCHAR2(2000 CHAR) NOT NULL, 
    c_facttablecolumn VARCHAR2(50 CHAR) NOT NULL, 
    c_basecode VARCHAR2(50 CHAR), 
    c_fullname VARCHAR2(700 CHAR) NOT NULL, 
    c_tablename VARCHAR2(50 CHAR) NOT NULL, 
    id NUMBER(10) NOT NULL, 
    update_date DATE NOT NULL, 
    m_exclusion_cd VARCHAR2(25 CHAR), 
    c_synonym_cd VARCHAR2(1 CHAR) NOT NULL, 
    valuetype_cd VARCHAR2(50 CHAR), 
    import_date DATE, 
    c_visualattributes VARCHAR2(3 CHAR) NOT NULL, 
    c_symbol VARCHAR2(50 CHAR), 
    m_applied_path VARCHAR2(700 CHAR) NOT NULL, 
    download_date DATE, 
    c_operator VARCHAR2(10 CHAR) NOT NULL, 
    sourcesystem_cd VARCHAR2(50 CHAR), 
    c_hlevel NUMBER NOT NULL, 
    c_columnname VARCHAR2(50 CHAR) NOT NULL, 
    c_totalnum NUMBER, 
    c_metadataxml CLOB, 
    c_tooltip VARCHAR2(900 CHAR), 
    c_comment CLOB, 
    c_path VARCHAR2(700 CHAR), 
    CONSTRAINT pk_i2b2 PRIMARY KEY (id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_i2b2_id ON i2b2 (id)

/

CREATE TABLE visit_dimension (
    update_date DATE, 
    download_date DATE, 
    end_date DATE, 
    active_status_cd VARCHAR2(50 CHAR), 
    import_date DATE, 
    upload_id NUMBER, 
    patient_num NUMBER NOT NULL, 
    sourcesystem_cd VARCHAR2(50 CHAR), 
    inout_cd VARCHAR2(50 CHAR), 
    location_path VARCHAR2(900 CHAR), 
    length_of_stay NUMBER, 
    visit_blob CLOB, 
    start_date DATE, 
    location_cd VARCHAR2(50 CHAR), 
    encounter_num NUMBER NOT NULL, 
    CONSTRAINT pk_visit_dimension PRIMARY KEY (encounter_num, patient_num) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_visit_dimension_enc_7d4c ON visit_dimension (encounter_num)

/

CREATE INDEX ix_visit_dimension_enc_5068 ON visit_dimension (encounter_num, patient_num)

/

CREATE INDEX ix_visit_dimension_enc_20cd ON visit_dimension (encounter_num, patient_num, location_path, inout_cd, start_date, end_date, length_of_stay)

/

CREATE INDEX ix_visit_dimension_sou_0d9c ON visit_dimension (sourcesystem_cd)

/

CREATE INDEX ix_visit_dimension_sta_5b9f ON visit_dimension (start_date, end_date)

/

CREATE INDEX ix_visit_dimension_upload_id ON visit_dimension (upload_id)

/

INSERT INTO alembic_version (version_num) VALUES ('1a2b15a3ecfc')

/

