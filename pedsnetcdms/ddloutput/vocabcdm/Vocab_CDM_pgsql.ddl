-- running migrations for 'Vocab CDM';

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

-- Running upgrade  -> 146969ca84d7

CREATE TABLE vocabulary (
    vocabulary_id INTEGER NOT NULL, 
    vocabulary_name VARCHAR(256) NOT NULL, 
    CONSTRAINT pk_vocabulary PRIMARY KEY (vocabulary_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT uq_vocabulary_vocabulary_name UNIQUE (vocabulary_name) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_vocabulary_vocabulary_id ON vocabulary (vocabulary_id);

CREATE TABLE drug_approval (
    ingredient_concept_id INTEGER NOT NULL, 
    approved_by VARCHAR(20) NOT NULL, 
    approval_date DATE NOT NULL, 
    CONSTRAINT pk_drug_approval PRIMARY KEY (ingredient_concept_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_drug_approval_ingredient_concept_id ON drug_approval (ingredient_concept_id);

CREATE TABLE drug_strength (
    ingredient_concept_id INTEGER NOT NULL, 
    valid_start_date DATE NOT NULL, 
    concentration_value NUMERIC(38, 0), 
    valid_end_date DATE NOT NULL, 
    amount_unit VARCHAR(60), 
    invalid_reason VARCHAR(1), 
    drug_concept_id INTEGER NOT NULL, 
    concentration_denom_unit VARCHAR(60), 
    concentration_enum_unit VARCHAR(60), 
    amount_value NUMERIC(38, 0), 
    CONSTRAINT pk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id, valid_end_date) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_drug_strength_drug_concept_id_ingredient_concept_id__523e ON drug_strength (drug_concept_id, ingredient_concept_id, valid_end_date);

CREATE TABLE relationship (
    defines_ancestry INTEGER DEFAULT '1' NOT NULL, 
    relationship_name VARCHAR(256) NOT NULL, 
    is_hierarchical INTEGER NOT NULL, 
    relationship_id INTEGER NOT NULL, 
    reverse_relationship INTEGER, 
    CONSTRAINT pk_relationship PRIMARY KEY (relationship_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_relationship_relationship_id ON relationship (relationship_id);

CREATE TABLE concept (
    vocabulary_id INTEGER NOT NULL, 
    valid_start_date DATE NOT NULL, 
    concept_level INTEGER NOT NULL, 
    valid_end_date DATE NOT NULL, 
    concept_name VARCHAR(256) NOT NULL, 
    concept_class VARCHAR(60) NOT NULL, 
    invalid_reason VARCHAR(1), 
    concept_code VARCHAR(40) NOT NULL, 
    concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_concept PRIMARY KEY (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_vocabulary_id_vocabulary FOREIGN KEY(vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_concept_concept_id ON concept (concept_id);

CREATE INDEX ix_concept_vocabulary_id ON concept (vocabulary_id);

CREATE TABLE concept_synonym (
    concept_synonym_id INTEGER NOT NULL, 
    concept_synonym_name VARCHAR(1000) NOT NULL, 
    concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_concept_synonym PRIMARY KEY (concept_synonym_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_synonym_concept_id_concept FOREIGN KEY(concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_concept_synonym_concept_id ON concept_synonym (concept_id);

CREATE INDEX ix_concept_synonym_concept_synonym_id ON concept_synonym (concept_synonym_id);

CREATE TABLE concept_relationship (
    valid_end_date DATE NOT NULL, 
    valid_start_date DATE NOT NULL, 
    invalid_reason VARCHAR(1), 
    concept_id_1 INTEGER NOT NULL, 
    relationship_id INTEGER NOT NULL, 
    concept_id_2 INTEGER NOT NULL, 
    CONSTRAINT pk_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_concept_id_1_concept FOREIGN KEY(concept_id_1) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_concept_id_2_concept FOREIGN KEY(concept_id_2) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_relationship_relationship_id_relationship FOREIGN KEY(relationship_id) REFERENCES relationship (relationship_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_concept_relationship_concept_id_1 ON concept_relationship (concept_id_1);

CREATE INDEX ix_concept_relationship_concept_id_1_concept_id_2_relat_ec36 ON concept_relationship (concept_id_1, concept_id_2, relationship_id);

CREATE INDEX ix_concept_relationship_concept_id_2 ON concept_relationship (concept_id_2);

CREATE INDEX ix_concept_relationship_relationship_id ON concept_relationship (relationship_id);

CREATE TABLE source_to_concept_map (
    valid_end_date DATE NOT NULL, 
    mapping_type VARCHAR(20), 
    valid_start_date DATE NOT NULL, 
    source_code_description VARCHAR(256), 
    invalid_reason VARCHAR(1), 
    primary_map VARCHAR(1), 
    target_vocabulary_id INTEGER NOT NULL, 
    source_code VARCHAR(40) NOT NULL, 
    source_vocabulary_id INTEGER NOT NULL, 
    target_concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_source_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_source_vocabulary_id_vocabulary FOREIGN KEY(source_vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_target_concept_id_concept FOREIGN KEY(target_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_source_to_concept_map_target_vocabulary_id_vocabulary FOREIGN KEY(target_vocabulary_id) REFERENCES vocabulary (vocabulary_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_source_to_concept_map_source_code ON source_to_concept_map (source_code varchar_pattern_ops);

CREATE INDEX ix_source_to_concept_map_source_vocabulary_id ON source_to_concept_map (source_vocabulary_id);

CREATE INDEX ix_source_to_concept_map_source_vocabulary_id_target_co_0d87 ON source_to_concept_map (source_vocabulary_id, target_concept_id, source_code varchar_pattern_ops, valid_end_date);

CREATE INDEX ix_source_to_concept_map_target_concept_id ON source_to_concept_map (target_concept_id);

CREATE INDEX ix_source_to_concept_map_target_vocabulary_id ON source_to_concept_map (target_vocabulary_id);

CREATE TABLE concept_ancestor (
    descendant_concept_id INTEGER NOT NULL, 
    min_levels_of_separation NUMERIC(38, 0), 
    ancestor_concept_id INTEGER NOT NULL, 
    max_levels_of_separation NUMERIC(38, 0), 
    CONSTRAINT pk_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_ancestor_ancestor_concept_id_concept FOREIGN KEY(ancestor_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED, 
    CONSTRAINT fk_concept_ancestor_descendant_concept_id_concept FOREIGN KEY(descendant_concept_id) REFERENCES concept (concept_id) DEFERRABLE INITIALLY DEFERRED
);

CREATE INDEX ix_concept_ancestor_ancestor_concept_id ON concept_ancestor (ancestor_concept_id);

CREATE INDEX ix_concept_ancestor_ancestor_concept_id_descendant_concept_id ON concept_ancestor (ancestor_concept_id, descendant_concept_id);

CREATE INDEX ix_concept_ancestor_descendant_concept_id ON concept_ancestor (descendant_concept_id);

INSERT INTO alembic_version (version_num) VALUES ('146969ca84d7');

