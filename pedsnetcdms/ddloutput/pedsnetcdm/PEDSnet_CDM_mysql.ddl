-- running migrations for 'PEDSnet CDM';

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

-- Running upgrade  -> cfbd6d35cab

CREATE TABLE location (
    city VARCHAR(50), 
    zip VARCHAR(9), 
    county VARCHAR(50), 
    state VARCHAR(2), 
    address_1 VARCHAR(100), 
    address_2 VARCHAR(100), 
    location_source_value VARCHAR(300), 
    location_id INTEGER NOT NULL AUTO_INCREMENT, 
    CONSTRAINT pk_location PRIMARY KEY (location_id)
);

CREATE INDEX ix_location_location_id ON location (location_id);

CREATE TABLE cohort (
    cohort_end_date DATETIME, 
    cohort_id INTEGER NOT NULL AUTO_INCREMENT, 
    subject_id INTEGER NOT NULL, 
    stop_reason VARCHAR(100), 
    cohort_concept_id INTEGER NOT NULL, 
    cohort_start_date DATETIME NOT NULL, 
    CONSTRAINT pk_cohort PRIMARY KEY (cohort_id)
);

CREATE INDEX ix_cohort_cohort_id ON cohort (cohort_id);

CREATE TABLE organization (
    organization_id INTEGER NOT NULL AUTO_INCREMENT, 
    place_of_service_concept_id INTEGER, 
    place_of_service_source_value VARCHAR(100), 
    location_id INTEGER, 
    organization_source_value VARCHAR(50) NOT NULL, 
    CONSTRAINT pk_organization PRIMARY KEY (organization_id), 
    CONSTRAINT fk_organization_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id), 
    CONSTRAINT uq_organization_organization_source_value UNIQUE (organization_source_value)
);

CREATE INDEX ix_organization_location_id ON organization (location_id);

CREATE INDEX ix_organization_organization_id ON organization (organization_id);

CREATE INDEX ix_organization_organization_source_value_place_of_servi_59cc ON organization (organization_source_value, place_of_service_source_value);

CREATE TABLE care_site (
    place_of_service_source_value VARCHAR(100), 
    place_of_service_concept_id INTEGER, 
    care_site_source_value VARCHAR(100) NOT NULL, 
    organization_id INTEGER NOT NULL, 
    care_site_id INTEGER NOT NULL AUTO_INCREMENT, 
    location_id INTEGER, 
    CONSTRAINT pk_care_site PRIMARY KEY (care_site_id), 
    CONSTRAINT fk_care_site_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id), 
    CONSTRAINT fk_care_site_organization_id_organization FOREIGN KEY(organization_id) REFERENCES organization (organization_id), 
    CONSTRAINT uq_care_site_organization_id_care_site_source_value UNIQUE (organization_id, care_site_source_value)
);

CREATE INDEX ix_care_site_care_site_id ON care_site (care_site_id);

CREATE INDEX ix_care_site_location_id ON care_site (location_id);

CREATE INDEX ix_care_site_organization_id ON care_site (organization_id);

CREATE TABLE provider (
    provider_id INTEGER NOT NULL AUTO_INCREMENT, 
    npi VARCHAR(20), 
    specialty_concept_id INTEGER, 
    provider_source_value VARCHAR(100) NOT NULL, 
    dea VARCHAR(20), 
    care_site_id INTEGER NOT NULL, 
    specialty_source_value VARCHAR(300), 
    CONSTRAINT pk_provider PRIMARY KEY (provider_id), 
    CONSTRAINT fk_provider_care_site_id_care_site FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id)
);

CREATE INDEX ix_provider_care_site_id ON provider (care_site_id);

CREATE INDEX ix_provider_provider_id ON provider (provider_id);

CREATE TABLE person (
    provider_id INTEGER, 
    ethnicity_concept_id INTEGER, 
    ethnicity_source_value VARCHAR(50), 
    person_source_value VARCHAR(100) NOT NULL, 
    month_of_birth NUMERIC(2, 0), 
    pn_time_of_birth DATETIME, 
    day_of_birth NUMERIC(2, 0), 
    year_of_birth NUMERIC(4, 0) NOT NULL, 
    gender_source_value VARCHAR(50), 
    race_source_value VARCHAR(50), 
    person_id INTEGER NOT NULL AUTO_INCREMENT, 
    care_site_id INTEGER NOT NULL, 
    gender_concept_id INTEGER NOT NULL, 
    location_id INTEGER, 
    race_concept_id INTEGER, 
    pn_gestational_age NUMERIC(4, 2), 
    CONSTRAINT pk_person PRIMARY KEY (person_id), 
    CONSTRAINT fk_person_care_site_id_care_site FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id), 
    CONSTRAINT fk_person_location_id_location FOREIGN KEY(location_id) REFERENCES location (location_id), 
    CONSTRAINT fk_person_provider_id_provider FOREIGN KEY(provider_id) REFERENCES provider (provider_id), 
    CONSTRAINT uq_person_person_source_value UNIQUE (person_source_value)
);

CREATE INDEX ix_person_care_site_id ON person (care_site_id);

CREATE INDEX ix_person_location_id ON person (location_id);

CREATE INDEX ix_person_person_id ON person (person_id);

CREATE INDEX ix_person_provider_id ON person (provider_id);

CREATE TABLE death (
    person_id INTEGER NOT NULL, 
    death_type_concept_id INTEGER NOT NULL, 
    death_date DATETIME NOT NULL, 
    cause_of_death_concept_id INTEGER NOT NULL, 
    cause_of_death_source_value VARCHAR(100), 
    CONSTRAINT pk_death PRIMARY KEY (person_id, death_type_concept_id, cause_of_death_concept_id), 
    CONSTRAINT fk_death_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_death_person_id ON death (person_id);

CREATE INDEX ix_death_person_id_death_type_concept_id_cause_of_death__50e7 ON death (person_id, death_type_concept_id, cause_of_death_concept_id);

CREATE TABLE visit_occurrence (
    provider_id INTEGER, 
    place_of_service_concept_id INTEGER NOT NULL, 
    visit_start_date DATETIME NOT NULL, 
    place_of_service_source_value VARCHAR(100), 
    visit_end_date DATETIME, 
    person_id INTEGER NOT NULL, 
    care_site_id INTEGER, 
    visit_occurrence_id INTEGER NOT NULL AUTO_INCREMENT, 
    CONSTRAINT pk_visit_occurrence PRIMARY KEY (visit_occurrence_id), 
    CONSTRAINT fk_visit_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_visit_occurrence_person_id ON visit_occurrence (person_id);

CREATE INDEX ix_visit_occurrence_person_id_visit_start_date ON visit_occurrence (person_id, visit_start_date);

CREATE INDEX ix_visit_occurrence_visit_occurrence_id ON visit_occurrence (visit_occurrence_id);

CREATE TABLE payer_plan_period (
    plan_source_value VARCHAR(100), 
    family_source_value VARCHAR(100), 
    payer_plan_period_id INTEGER NOT NULL AUTO_INCREMENT, 
    payer_plan_period_end_date DATETIME NOT NULL, 
    person_id INTEGER NOT NULL, 
    payer_source_value VARCHAR(100), 
    payer_plan_period_start_date DATETIME NOT NULL, 
    CONSTRAINT pk_payer_plan_period PRIMARY KEY (payer_plan_period_id), 
    CONSTRAINT fk_payer_plan_period_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_payer_plan_period_payer_plan_period_id ON payer_plan_period (payer_plan_period_id);

CREATE INDEX ix_payer_plan_period_person_id ON payer_plan_period (person_id);

CREATE TABLE drug_era (
    drug_era_end_date DATETIME NOT NULL, 
    drug_era_start_date DATETIME NOT NULL, 
    person_id INTEGER NOT NULL, 
    drug_era_id INTEGER NOT NULL AUTO_INCREMENT, 
    drug_exposure_count NUMERIC(4, 0), 
    drug_type_concept_id INTEGER NOT NULL, 
    drug_concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_drug_era PRIMARY KEY (drug_era_id), 
    CONSTRAINT fk_drug_era_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_drug_era_drug_era_id ON drug_era (drug_era_id);

CREATE INDEX ix_drug_era_person_id ON drug_era (person_id);

CREATE TABLE observation_period (
    person_id INTEGER NOT NULL, 
    observation_period_end_date DATETIME, 
    observation_period_start_date DATETIME NOT NULL, 
    observation_period_id INTEGER NOT NULL AUTO_INCREMENT, 
    CONSTRAINT pk_observation_period PRIMARY KEY (observation_period_id), 
    CONSTRAINT fk_observation_period_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_observation_period_observation_period_id ON observation_period (observation_period_id);

CREATE INDEX ix_observation_period_person_id ON observation_period (person_id);

CREATE INDEX ix_observation_period_person_id_observation_period_start_date ON observation_period (person_id, observation_period_start_date);

CREATE TABLE condition_era (
    condition_concept_id INTEGER NOT NULL, 
    condition_occurrence_count NUMERIC(4, 0), 
    condition_era_id INTEGER NOT NULL AUTO_INCREMENT, 
    condition_type_concept_id INTEGER NOT NULL, 
    condition_era_start_date DATETIME NOT NULL, 
    person_id INTEGER NOT NULL, 
    condition_era_end_date DATETIME NOT NULL, 
    CONSTRAINT pk_condition_era PRIMARY KEY (condition_era_id), 
    CONSTRAINT fk_condition_era_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id)
);

CREATE INDEX ix_condition_era_condition_era_id ON condition_era (condition_era_id);

CREATE INDEX ix_condition_era_person_id ON condition_era (person_id);

CREATE TABLE observation (
    range_high NUMERIC(14, 3), 
    observation_concept_id INTEGER NOT NULL, 
    range_low NUMERIC(14, 3), 
    observation_id INTEGER NOT NULL AUTO_INCREMENT, 
    relevant_condition_concept_id INTEGER, 
    observation_time DATETIME, 
    unit_concept_id INTEGER, 
    value_as_number NUMERIC(14, 3), 
    observation_source_value VARCHAR(100), 
    value_as_string VARCHAR(4000), 
    observation_type_concept_id INTEGER NOT NULL, 
    person_id INTEGER NOT NULL, 
    observation_date DATETIME NOT NULL, 
    value_as_concept_id INTEGER, 
    associated_provider_id INTEGER, 
    visit_occurrence_id INTEGER, 
    units_source_value VARCHAR(100), 
    CONSTRAINT pk_observation PRIMARY KEY (observation_id), 
    CONSTRAINT fk_observation_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
    CONSTRAINT fk_observation_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id), 
    CONSTRAINT fk_observation_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
);

CREATE INDEX ix_observation_associated_provider_id ON observation (associated_provider_id);

CREATE INDEX ix_observation_observation_id ON observation (observation_id);

CREATE INDEX ix_observation_person_id ON observation (person_id);

CREATE INDEX ix_observation_person_id_observation_concept_id ON observation (person_id, observation_concept_id);

CREATE INDEX ix_observation_visit_occurrence_id ON observation (visit_occurrence_id);

CREATE TABLE drug_exposure (
    refills NUMERIC(3, 0), 
    stop_reason VARCHAR(100), 
    relevant_condition_concept_id INTEGER, 
    days_supply NUMERIC(4, 0), 
    drug_exposure_start_date DATETIME NOT NULL, 
    prescribing_provider_id INTEGER, 
    sig VARCHAR(500), 
    drug_exposure_id INTEGER NOT NULL AUTO_INCREMENT, 
    drug_source_value VARCHAR(100), 
    person_id INTEGER NOT NULL, 
    drug_exposure_end_date DATETIME, 
    visit_occurrence_id INTEGER, 
    drug_type_concept_id INTEGER NOT NULL, 
    drug_concept_id INTEGER NOT NULL, 
    quantity NUMERIC(4, 0), 
    CONSTRAINT pk_drug_exposure PRIMARY KEY (drug_exposure_id), 
    CONSTRAINT fk_drug_exposure_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id), 
    CONSTRAINT fk_drug_exposure_prescribing_provider_id_provider FOREIGN KEY(prescribing_provider_id) REFERENCES provider (provider_id), 
    CONSTRAINT fk_drug_exposure_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
);

CREATE INDEX ix_drug_exposure_drug_exposure_id ON drug_exposure (drug_exposure_id);

CREATE INDEX ix_drug_exposure_person_id ON drug_exposure (person_id);

CREATE INDEX ix_drug_exposure_prescribing_provider_id ON drug_exposure (prescribing_provider_id);

CREATE INDEX ix_drug_exposure_visit_occurrence_id ON drug_exposure (visit_occurrence_id);

CREATE TABLE procedure_occurrence (
    procedure_concept_id INTEGER NOT NULL, 
    relevant_condition_concept_id INTEGER, 
    procedure_date DATETIME NOT NULL, 
    person_id INTEGER NOT NULL, 
    procedure_type_concept_id INTEGER NOT NULL, 
    procedure_source_value VARCHAR(100), 
    procedure_occurrence_id INTEGER NOT NULL AUTO_INCREMENT, 
    associated_provider_id INTEGER, 
    visit_occurrence_id INTEGER, 
    CONSTRAINT pk_procedure_occurrence PRIMARY KEY (procedure_occurrence_id), 
    CONSTRAINT fk_procedure_occurrence_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
    CONSTRAINT fk_procedure_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id), 
    CONSTRAINT fk_procedure_occurrence_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
);

CREATE INDEX ix_procedure_occurrence_associated_provider_id ON procedure_occurrence (associated_provider_id);

CREATE INDEX ix_procedure_occurrence_person_id ON procedure_occurrence (person_id);

CREATE INDEX ix_procedure_occurrence_procedure_occurrence_id ON procedure_occurrence (procedure_occurrence_id);

CREATE INDEX ix_procedure_occurrence_visit_occurrence_id ON procedure_occurrence (visit_occurrence_id);

CREATE TABLE condition_occurrence (
    condition_concept_id INTEGER NOT NULL, 
    condition_type_concept_id INTEGER NOT NULL, 
    stop_reason VARCHAR(100), 
    condition_start_date DATETIME NOT NULL, 
    condition_end_date DATETIME, 
    person_id INTEGER NOT NULL, 
    condition_source_value VARCHAR(100), 
    condition_occurrence_id INTEGER NOT NULL AUTO_INCREMENT, 
    associated_provider_id INTEGER, 
    visit_occurrence_id INTEGER, 
    CONSTRAINT pk_condition_occurrence PRIMARY KEY (condition_occurrence_id), 
    CONSTRAINT fk_condition_occurrence_associated_provider_id_provider FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
    CONSTRAINT fk_condition_occurrence_person_id_person FOREIGN KEY(person_id) REFERENCES person (person_id), 
    CONSTRAINT fk_condition_occurrence_visit_occurrence_id_visit_occurrence FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
);

CREATE INDEX ix_condition_occurrence_associated_provider_id ON condition_occurrence (associated_provider_id);

CREATE INDEX ix_condition_occurrence_condition_occurrence_id ON condition_occurrence (condition_occurrence_id);

CREATE INDEX ix_condition_occurrence_person_id ON condition_occurrence (person_id);

CREATE INDEX ix_condition_occurrence_visit_occurrence_id ON condition_occurrence (visit_occurrence_id);

CREATE TABLE procedure_cost (
    total_out_of_pocket NUMERIC(8, 2), 
    revenue_code_source_value VARCHAR(100), 
    paid_toward_deductible NUMERIC(8, 2), 
    revenue_code_concept_id INTEGER, 
    payer_plan_period_id INTEGER, 
    paid_by_payer NUMERIC(8, 2), 
    procedure_cost_id INTEGER NOT NULL AUTO_INCREMENT, 
    paid_copay NUMERIC(8, 2), 
    paid_coinsurance NUMERIC(8, 2), 
    paid_by_coordination_benefits NUMERIC(8, 2), 
    procedure_occurrence_id INTEGER NOT NULL, 
    total_paid NUMERIC(8, 2), 
    disease_class_concept_id INTEGER, 
    disease_class_source_value VARCHAR(100), 
    CONSTRAINT pk_procedure_cost PRIMARY KEY (procedure_cost_id), 
    CONSTRAINT fk_procedure_cost_payer_plan_period_id_payer_plan_period FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id), 
    CONSTRAINT fk_procedure_cost_procedure_occurrence_id_procedure_occurrence FOREIGN KEY(procedure_occurrence_id) REFERENCES procedure_occurrence (procedure_occurrence_id)
);

CREATE INDEX ix_procedure_cost_payer_plan_period_id ON procedure_cost (payer_plan_period_id);

CREATE INDEX ix_procedure_cost_procedure_cost_id ON procedure_cost (procedure_cost_id);

CREATE INDEX ix_procedure_cost_procedure_occurrence_id ON procedure_cost (procedure_occurrence_id);

CREATE TABLE drug_cost (
    total_out_of_pocket NUMERIC(8, 2), 
    paid_toward_deductible NUMERIC(8, 2), 
    payer_plan_period_id INTEGER, 
    drug_cost_id INTEGER NOT NULL AUTO_INCREMENT, 
    paid_by_payer NUMERIC(8, 2), 
    drug_exposure_id INTEGER NOT NULL, 
    paid_copay NUMERIC(8, 2), 
    paid_coinsurance NUMERIC(8, 2), 
    paid_by_coordination_benefits NUMERIC(8, 2), 
    average_wholesale_price NUMERIC(8, 2), 
    ingredient_cost NUMERIC(8, 2), 
    total_paid NUMERIC(8, 2), 
    dispensing_fee NUMERIC(8, 2), 
    CONSTRAINT pk_drug_cost PRIMARY KEY (drug_cost_id), 
    CONSTRAINT fk_drug_cost_drug_exposure_id_drug_exposure FOREIGN KEY(drug_exposure_id) REFERENCES drug_exposure (drug_exposure_id), 
    CONSTRAINT fk_drug_cost_payer_plan_period_id_payer_plan_period FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id)
);

CREATE INDEX ix_drug_cost_drug_cost_id ON drug_cost (drug_cost_id);

CREATE INDEX ix_drug_cost_drug_exposure_id ON drug_cost (drug_exposure_id);

CREATE INDEX ix_drug_cost_payer_plan_period_id ON drug_cost (payer_plan_period_id);

INSERT INTO alembic_version (version_num) VALUES ('cfbd6d35cab');

