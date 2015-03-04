-- running migrations for 'PEDSnet CDM'

/

CREATE TABLE alembic_version (
    version_num VARCHAR2(32 CHAR) NOT NULL
)

/

-- Running upgrade  -> cfbd6d35cab

CREATE TABLE location (
    city VARCHAR2(50 CHAR), 
    zip VARCHAR2(9 CHAR), 
    county VARCHAR2(50 CHAR), 
    state VARCHAR2(2 CHAR), 
    address_1 VARCHAR2(100 CHAR), 
    address_2 VARCHAR2(100 CHAR), 
    location_source_value VARCHAR2(300 CHAR), 
    location_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_location PRIMARY KEY (location_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_location_location_id ON location (location_id)

/

CREATE TABLE cohort (
    cohort_end_date DATE, 
    cohort_id NUMBER(10) NOT NULL, 
    subject_id NUMBER(10) NOT NULL, 
    stop_reason VARCHAR2(100 CHAR), 
    cohort_concept_id NUMBER(10) NOT NULL, 
    cohort_start_date DATE NOT NULL, 
    CONSTRAINT pk_cohort PRIMARY KEY (cohort_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_cohort_cohort_id ON cohort (cohort_id)

/

CREATE TABLE organization (
    organization_id NUMBER(10) NOT NULL, 
    place_of_service_concept_id NUMBER(10), 
    place_of_service_source_value VARCHAR2(100 CHAR), 
    location_id NUMBER(10), 
    organization_source_value VARCHAR2(50 CHAR) NOT NULL, 
    CONSTRAINT pk_organization PRIMARY KEY (organization_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_organization_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT uq_organization_organization_source_value UNIQUE (organization_source_value) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_organization_location_id ON organization (location_id)

/

CREATE INDEX ix_organization_organi_0044 ON organization (organization_id)

/

CREATE INDEX ix_organization_organi_59cc ON organization (organization_source_value, place_of_service_source_value)

/

CREATE TABLE care_site (
    place_of_service_source_value VARCHAR2(100 CHAR), 
    place_of_service_concept_id NUMBER(10), 
    care_site_source_value VARCHAR2(100 CHAR) NOT NULL, 
    organization_id NUMBER(10) NOT NULL, 
    care_site_id NUMBER(10) NOT NULL, 
    location_id NUMBER(10), 
    CONSTRAINT pk_care_site PRIMARY KEY (care_site_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_care_site_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_care_site_organization_id_organization FOREIGN KEY(organization_id) REFERENCES organization (organization_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT uq_care_site_organization_id_care_site_source_value UNIQUE (organization_id, care_site_source_value) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_care_site_care_site_id ON care_site (care_site_id)

/

CREATE INDEX ix_care_site_location_id ON care_site (location_id)

/

CREATE INDEX ix_care_site_organization_id ON care_site (organization_id)

/

CREATE TABLE provider (
    provider_id NUMBER(10) NOT NULL, 
    npi VARCHAR2(20 CHAR), 
    specialty_concept_id NUMBER(10), 
    provider_source_value VARCHAR2(100 CHAR) NOT NULL, 
    dea VARCHAR2(20 CHAR), 
    care_site_id NUMBER(10) NOT NULL, 
    specialty_source_value VARCHAR2(300 CHAR), 
    CONSTRAINT pk_provider PRIMARY KEY (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_provider_care_site_id_care_site FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_provider_care_site_id ON provider (care_site_id)

/

CREATE INDEX ix_provider_provider_id ON provider (provider_id)

/

CREATE TABLE person (
    provider_id NUMBER(10), 
    ethnicity_concept_id NUMBER(10), 
    ethnicity_source_value VARCHAR2(50 CHAR), 
    person_source_value VARCHAR2(100 CHAR) NOT NULL, 
    month_of_birth NUMBER, 
    pn_time_of_birth DATE, 
    day_of_birth NUMBER, 
    year_of_birth NUMBER NOT NULL, 
    gender_source_value VARCHAR2(50 CHAR), 
    race_source_value VARCHAR2(50 CHAR), 
    person_id NUMBER(10) NOT NULL, 
    care_site_id NUMBER(10) NOT NULL, 
    gender_concept_id NUMBER(10) NOT NULL, 
    location_id NUMBER(10), 
    race_concept_id NUMBER(10), 
    pn_gestational_age NUMBER, 
    CONSTRAINT pk_person PRIMARY KEY (person_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_person_care_site_id_care_site FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_person_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_person_provider_id_provider FOREIGN KEY(provider_id) REFERENCES provider (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT uq_person_person_source_value UNIQUE (person_source_value) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_person_care_site_id ON person (care_site_id)

/

CREATE INDEX ix_person_location_id ON person (location_id)

/

CREATE INDEX ix_person_person_id ON person (person_id)

/

CREATE INDEX ix_person_provider_id ON person (provider_id)

/

CREATE TABLE death (
    person_id NUMBER(10) NOT NULL, 
    death_type_concept_id NUMBER(10) NOT NULL, 
    death_date DATE NOT NULL, 
    cause_of_death_concept_id NUMBER(10) NOT NULL, 
    cause_of_death_source_value VARCHAR2(100 CHAR), 
    CONSTRAINT pk_death PRIMARY KEY (person_id, death_type_concept_id, cause_of_death_concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_death_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_death_person_id ON death (person_id)

/

CREATE INDEX ix_death_person_id_dea_50e7 ON death (person_id, death_type_concept_id, cause_of_death_concept_id)

/

CREATE TABLE visit_occurrence (
    provider_id NUMBER(10), 
    place_of_service_concept_id NUMBER(10) NOT NULL, 
    visit_start_date DATE NOT NULL, 
    place_of_service_source_value VARCHAR2(100 CHAR), 
    visit_end_date DATE, 
    person_id NUMBER(10) NOT NULL, 
    care_site_id NUMBER(10), 
    visit_occurrence_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_visit_occurrence PRIMARY KEY (visit_occurrence_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_visit_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_visit_occurrence_person_id ON visit_occurrence (person_id)

/

CREATE INDEX ix_visit_occurrence_pe_19a3 ON visit_occurrence (person_id, visit_start_date)

/

CREATE INDEX ix_visit_occurrence_vi_83e5 ON visit_occurrence (visit_occurrence_id)

/

CREATE TABLE payer_plan_period (
    plan_source_value VARCHAR2(100 CHAR), 
    family_source_value VARCHAR2(100 CHAR), 
    payer_plan_period_id NUMBER(10) NOT NULL, 
    payer_plan_period_end_date DATE NOT NULL, 
    person_id NUMBER(10) NOT NULL, 
    payer_source_value VARCHAR2(100 CHAR), 
    payer_plan_period_start_date DATE NOT NULL, 
    CONSTRAINT pk_payer_plan_period PRIMARY KEY (payer_plan_period_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_payer_plan_period_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_payer_plan_period_p_943d ON payer_plan_period (payer_plan_period_id)

/

CREATE INDEX ix_payer_plan_period_person_id ON payer_plan_period (person_id)

/

CREATE TABLE drug_era (
    drug_era_end_date DATE NOT NULL, 
    drug_era_start_date DATE NOT NULL, 
    person_id NUMBER(10) NOT NULL, 
    drug_era_id NUMBER(10) NOT NULL, 
    drug_exposure_count NUMBER, 
    drug_type_concept_id NUMBER(10) NOT NULL, 
    drug_concept_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_drug_era PRIMARY KEY (drug_era_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_era_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_drug_era_drug_era_id ON drug_era (drug_era_id)

/

CREATE INDEX ix_drug_era_person_id ON drug_era (person_id)

/

CREATE TABLE observation_period (
    person_id NUMBER(10) NOT NULL, 
    observation_period_end_date DATE, 
    observation_period_start_date DATE NOT NULL, 
    observation_period_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_observation_period PRIMARY KEY (observation_period_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_observation_period_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_observation_period__5935 ON observation_period (observation_period_id)

/

CREATE INDEX ix_observation_period__86e1 ON observation_period (person_id)

/

CREATE INDEX ix_observation_period__9d2e ON observation_period (person_id, observation_period_start_date)

/

CREATE TABLE condition_era (
    condition_concept_id NUMBER(10) NOT NULL, 
    condition_occurrence_count NUMBER, 
    condition_era_id NUMBER(10) NOT NULL, 
    condition_type_concept_id NUMBER(10) NOT NULL, 
    condition_era_start_date DATE NOT NULL, 
    person_id NUMBER(10) NOT NULL, 
    condition_era_end_date DATE NOT NULL, 
    CONSTRAINT pk_condition_era PRIMARY KEY (condition_era_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_condition_era_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_condition_era_condi_15d5 ON condition_era (condition_era_id)

/

CREATE INDEX ix_condition_era_person_id ON condition_era (person_id)

/

CREATE TABLE observation (
    range_high NUMBER, 
    observation_concept_id NUMBER(10) NOT NULL, 
    range_low NUMBER, 
    observation_id NUMBER(10) NOT NULL, 
    relevant_condition_concept_id NUMBER(10), 
    observation_time DATE, 
    unit_concept_id NUMBER(10), 
    value_as_number NUMBER, 
    observation_source_value VARCHAR2(100 CHAR), 
    value_as_string VARCHAR2(4000 CHAR), 
    observation_type_concept_id NUMBER(10) NOT NULL, 
    person_id NUMBER(10) NOT NULL, 
    observation_date DATE NOT NULL, 
    value_as_concept_id NUMBER(10), 
    associated_provider_id NUMBER(10), 
    visit_occurrence_id NUMBER(10), 
    units_source_value VARCHAR2(100 CHAR), 
    CONSTRAINT pk_observation PRIMARY KEY (observation_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_observation_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_observation_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_observation_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_observation_associa_9353 ON observation (associated_provider_id)

/

CREATE INDEX ix_observation_observation_id ON observation (observation_id)

/

CREATE INDEX ix_observation_person_id ON observation (person_id)

/

CREATE INDEX ix_observation_person__c044 ON observation (person_id, observation_concept_id)

/

CREATE INDEX ix_observation_visit_o_ee66 ON observation (visit_occurrence_id)

/

CREATE TABLE drug_exposure (
    refills NUMBER, 
    stop_reason VARCHAR2(100 CHAR), 
    relevant_condition_concept_id NUMBER(10), 
    days_supply NUMBER, 
    drug_exposure_start_date DATE NOT NULL, 
    prescribing_provider_id NUMBER(10), 
    sig VARCHAR2(500 CHAR), 
    drug_exposure_id NUMBER(10) NOT NULL, 
    drug_source_value VARCHAR2(100 CHAR), 
    person_id NUMBER(10) NOT NULL, 
    drug_exposure_end_date DATE, 
    visit_occurrence_id NUMBER(10), 
    drug_type_concept_id NUMBER(10) NOT NULL, 
    drug_concept_id NUMBER(10) NOT NULL, 
    quantity NUMBER, 
    CONSTRAINT pk_drug_exposure PRIMARY KEY (drug_exposure_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_exposure_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_exposure_prescribing_provider_id_provider FOREIGN KEY(prescribing_provider_id) REFERENCES provider (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_exposure_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_drug_exposure_drug__e808 ON drug_exposure (drug_exposure_id)

/

CREATE INDEX ix_drug_exposure_person_id ON drug_exposure (person_id)

/

CREATE INDEX ix_drug_exposure_presc_5149 ON drug_exposure (prescribing_provider_id)

/

CREATE INDEX ix_drug_exposure_visit_122d ON drug_exposure (visit_occurrence_id)

/

CREATE TABLE procedure_occurrence (
    procedure_concept_id NUMBER(10) NOT NULL, 
    relevant_condition_concept_id NUMBER(10), 
    procedure_date DATE NOT NULL, 
    person_id NUMBER(10) NOT NULL, 
    procedure_type_concept_id NUMBER(10) NOT NULL, 
    procedure_source_value VARCHAR2(100 CHAR), 
    procedure_occurrence_id NUMBER(10) NOT NULL, 
    associated_provider_id NUMBER(10), 
    visit_occurrence_id NUMBER(10), 
    CONSTRAINT pk_procedure_occurrence PRIMARY KEY (procedure_occurrence_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_procedure_occurrence_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_procedure_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_procedure_occurrence_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_procedure_occurrenc_a24c ON procedure_occurrence (associated_provider_id)

/

CREATE INDEX ix_procedure_occurrenc_80fe ON procedure_occurrence (person_id)

/

CREATE INDEX ix_procedure_occurrenc_fe8e ON procedure_occurrence (procedure_occurrence_id)

/

CREATE INDEX ix_procedure_occurrenc_d11b ON procedure_occurrence (visit_occurrence_id)

/

CREATE TABLE condition_occurrence (
    condition_concept_id NUMBER(10) NOT NULL, 
    condition_type_concept_id NUMBER(10) NOT NULL, 
    stop_reason VARCHAR2(100 CHAR), 
    condition_start_date DATE NOT NULL, 
    condition_end_date DATE, 
    person_id NUMBER(10) NOT NULL, 
    condition_source_value VARCHAR2(100 CHAR), 
    condition_occurrence_id NUMBER(10) NOT NULL, 
    associated_provider_id NUMBER(10), 
    visit_occurrence_id NUMBER(10), 
    CONSTRAINT pk_condition_occurrence PRIMARY KEY (condition_occurrence_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_condition_occurrence_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_condition_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_condition_occurrence_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_condition_occurrenc_324d ON condition_occurrence (associated_provider_id)

/

CREATE INDEX ix_condition_occurrenc_4213 ON condition_occurrence (condition_occurrence_id)

/

CREATE INDEX ix_condition_occurrenc_1463 ON condition_occurrence (person_id)

/

CREATE INDEX ix_condition_occurrenc_a6c3 ON condition_occurrence (visit_occurrence_id)

/

CREATE TABLE procedure_cost (
    total_out_of_pocket NUMBER, 
    revenue_code_source_value VARCHAR2(100 CHAR), 
    paid_toward_deductible NUMBER, 
    revenue_code_concept_id NUMBER(10), 
    payer_plan_period_id NUMBER(10), 
    paid_by_payer NUMBER, 
    procedure_cost_id NUMBER(10) NOT NULL, 
    paid_copay NUMBER, 
    paid_coinsurance NUMBER, 
    paid_by_coordination_benefits NUMBER, 
    procedure_occurrence_id NUMBER(10) NOT NULL, 
    total_paid NUMBER, 
    disease_class_concept_id NUMBER(10), 
    disease_class_source_value VARCHAR2(100 CHAR), 
    CONSTRAINT pk_procedure_cost PRIMARY KEY (procedure_cost_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_procedure_cost_payer_plan_period_id_payer_plan_period FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_procedure_cost_procedure_occurrence_id_procedure_occurrence FOREIGN KEY(procedure_occurrence_id) REFERENCES procedure_occurrence (procedure_occurrence_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_procedure_cost_paye_2334 ON procedure_cost (payer_plan_period_id)

/

CREATE INDEX ix_procedure_cost_proc_1c3b ON procedure_cost (procedure_cost_id)

/

CREATE INDEX ix_procedure_cost_proc_c989 ON procedure_cost (procedure_occurrence_id)

/

CREATE TABLE drug_cost (
    total_out_of_pocket NUMBER, 
    paid_toward_deductible NUMBER, 
    payer_plan_period_id NUMBER(10), 
    drug_cost_id NUMBER(10) NOT NULL, 
    paid_by_payer NUMBER, 
    drug_exposure_id NUMBER(10) NOT NULL, 
    paid_copay NUMBER, 
    paid_coinsurance NUMBER, 
    paid_by_coordination_benefits NUMBER, 
    average_wholesale_price NUMBER, 
    ingredient_cost NUMBER, 
    total_paid NUMBER, 
    dispensing_fee NUMBER, 
    CONSTRAINT pk_drug_cost PRIMARY KEY (drug_cost_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_cost_drug_exposure_id_drug_exposure FOREIGN KEY(drug_exposure_id) REFERENCES drug_exposure (drug_exposure_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_drug_cost_payer_plan_period_id_payer_plan_period FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_drug_cost_drug_cost_id ON drug_cost (drug_cost_id)

/

CREATE INDEX ix_drug_cost_drug_exposure_id ON drug_cost (drug_exposure_id)

/

CREATE INDEX ix_drug_cost_payer_pla_51f7 ON drug_cost (payer_plan_period_id)

/

INSERT INTO alembic_version (version_num) VALUES ('cfbd6d35cab')

/

