-- running migrations for 'Vocab CDM'

/

CREATE TABLE alembic_version (
    version_num VARCHAR2(32 CHAR) NOT NULL
)

/

-- Running upgrade  -> 146969ca84d7

CREATE TABLE vocabulary (
    vocabulary_id NUMBER(10) NOT NULL, 
    vocabulary_name VARCHAR2(256 CHAR) NOT NULL, 
    CONSTRAINT pk_vocabulary PRIMARY KEY (vocabulary_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT uq_vocabulary_vocabulary_name UNIQUE (vocabulary_name) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_vocabulary_vocabulary_id ON vocabulary (vocabulary_id)

/

CREATE TABLE drug_approval (
    ingredient_concept_id NUMBER(10) NOT NULL, 
    approved_by VARCHAR2(20 CHAR) NOT NULL, 
    approval_date DATE NOT NULL, 
    CONSTRAINT pk_drug_approval PRIMARY KEY (ingredient_concept_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_drug_approval_ingre_dcd3 ON drug_approval (ingredient_concept_id)

/

CREATE TABLE drug_strength (
    ingredient_concept_id NUMBER(10) NOT NULL, 
    valid_start_date DATE NOT NULL, 
    concentration_value NUMBER, 
    valid_end_date DATE NOT NULL, 
    amount_unit VARCHAR2(60 CHAR), 
    invalid_reason VARCHAR2(1 CHAR), 
    drug_concept_id NUMBER(10) NOT NULL, 
    concentration_denom_unit VARCHAR2(60 CHAR), 
    concentration_enum_unit VARCHAR2(60 CHAR), 
    amount_value NUMBER, 
    CONSTRAINT pk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id, valid_end_date) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_drug_strength_drug__523e ON drug_strength (drug_concept_id, ingredient_concept_id, valid_end_date)

/

CREATE TABLE relationship (
    defines_ancestry NUMBER(10) DEFAULT '1' NOT NULL, 
    relationship_name VARCHAR2(256 CHAR) NOT NULL, 
    is_hierarchical NUMBER(10) NOT NULL, 
    relationship_id NUMBER(10) NOT NULL, 
    reverse_relationship NUMBER(10), 
    CONSTRAINT pk_relationship PRIMARY KEY (relationship_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_relationship_relati_b789 ON relationship (relationship_id)

/

CREATE TABLE concept (
    vocabulary_id NUMBER(10) NOT NULL, 
    valid_start_date DATE NOT NULL, 
    concept_level NUMBER(10) NOT NULL, 
    valid_end_date DATE NOT NULL, 
    concept_name VARCHAR2(256 CHAR) NOT NULL, 
    concept_class VARCHAR2(60 CHAR) NOT NULL, 
    invalid_reason VARCHAR2(1 CHAR), 
    concept_code VARCHAR2(40 CHAR) NOT NULL, 
    concept_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_concept PRIMARY KEY (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_vocabulary_id_vocabulary FOREIGN KEY(vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_concept_concept_id ON concept (concept_id)

/

CREATE INDEX ix_concept_vocabulary_id ON concept (vocabulary_id)

/

CREATE TABLE concept_synonym (
    concept_synonym_id NUMBER(10) NOT NULL, 
    concept_synonym_name VARCHAR2(1000 CHAR) NOT NULL, 
    concept_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_concept_synonym PRIMARY KEY (concept_synonym_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_synonym_concept_id_concept FOREIGN KEY(concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_concept_synonym_concept_id ON concept_synonym (concept_id)

/

CREATE INDEX ix_concept_synonym_con_718d ON concept_synonym (concept_synonym_id)

/

CREATE TABLE concept_relationship (
    valid_end_date DATE NOT NULL, 
    valid_start_date DATE NOT NULL, 
    invalid_reason VARCHAR2(1 CHAR), 
    concept_id_1 NUMBER(10) NOT NULL, 
    relationship_id NUMBER(10) NOT NULL, 
    concept_id_2 NUMBER(10) NOT NULL, 
    CONSTRAINT pk_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_concept_id_1_concept FOREIGN KEY(concept_id_1) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_concept_id_2_concept FOREIGN KEY(concept_id_2) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_relationship_id_relationship FOREIGN KEY(relationship_id) REFERENCES relationship (relationship_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_concept_relationshi_b294 ON concept_relationship (concept_id_1)

/

CREATE INDEX ix_concept_relationshi_ec36 ON concept_relationship (concept_id_1, concept_id_2, relationship_id)

/

CREATE INDEX ix_concept_relationshi_fa18 ON concept_relationship (concept_id_2)

/

CREATE INDEX ix_concept_relationshi_1912 ON concept_relationship (relationship_id)

/

CREATE TABLE source_to_concept_map (
    valid_end_date DATE NOT NULL, 
    mapping_type VARCHAR2(20 CHAR), 
    valid_start_date DATE NOT NULL, 
    source_code_description VARCHAR2(256 CHAR), 
    invalid_reason VARCHAR2(1 CHAR), 
    primary_map VARCHAR2(1 CHAR), 
    target_vocabulary_id NUMBER(10) NOT NULL, 
    source_code VARCHAR2(40 CHAR) NOT NULL, 
    source_vocabulary_id NUMBER(10) NOT NULL, 
    target_concept_id NUMBER(10) NOT NULL, 
    CONSTRAINT pk_source_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_source_vocabulary_id_vocabulary FOREIGN KEY(source_vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_target_concept_id_concept FOREIGN KEY(target_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_target_vocabulary_id_vocabulary FOREIGN KEY(target_vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_source_to_concept_m_bb4a ON source_to_concept_map (source_code)

/

CREATE INDEX ix_source_to_concept_m_1c76 ON source_to_concept_map (source_vocabulary_id)

/

CREATE INDEX ix_source_to_concept_m_0d87 ON source_to_concept_map (source_vocabulary_id, target_concept_id, source_code, valid_end_date)

/

CREATE INDEX ix_source_to_concept_m_8b58 ON source_to_concept_map (target_concept_id)

/

CREATE INDEX ix_source_to_concept_m_72c5 ON source_to_concept_map (target_vocabulary_id)

/

CREATE TABLE concept_ancestor (
    descendant_concept_id NUMBER(10) NOT NULL, 
    min_levels_of_separation NUMBER, 
    ancestor_concept_id NUMBER(10) NOT NULL, 
    max_levels_of_separation NUMBER, 
    CONSTRAINT pk_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_ancestor_ancestor_concept_id_concept FOREIGN KEY(ancestor_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_ancestor_descendant_concept_id_concept FOREIGN KEY(descendant_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED
)

/

CREATE INDEX ix_concept_ancestor_an_cfc0 ON concept_ancestor (ancestor_concept_id)

/

CREATE INDEX ix_concept_ancestor_an_9a92 ON concept_ancestor (ancestor_concept_id, descendant_concept_id)

/

CREATE INDEX ix_concept_ancestor_de_7d67 ON concept_ancestor (descendant_concept_id)

/

INSERT INTO alembic_version (version_num) VALUES ('146969ca84d7')

/

