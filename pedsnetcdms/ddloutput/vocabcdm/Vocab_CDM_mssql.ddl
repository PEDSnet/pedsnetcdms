-- running migrations for 'Vocab CDM';

GO

CREATE TABLE alembic_version (
    version_num VARCHAR(32) NOT NULL
);

GO

-- Running upgrade  -> 146969ca84d7

CREATE TABLE vocabulary (
    vocabulary_id INTEGER NOT NULL, 
    vocabulary_name VARCHAR(256) NOT NULL, 
    CONSTRAINT pk_vocabulary PRIMARY KEY (vocabulary_id), 
    CONSTRAINT uq_vocabulary_vocabulary_name UNIQUE (vocabulary_name)
);

GO

CREATE INDEX ix_vocabulary_vocabulary_id ON vocabulary (vocabulary_id);

GO

CREATE TABLE drug_approval (
    ingredient_concept_id INTEGER NOT NULL, 
    approved_by VARCHAR(20) NOT NULL, 
    approval_date DATETIME NOT NULL, 
    CONSTRAINT pk_drug_approval PRIMARY KEY (ingredient_concept_id)
);

GO

CREATE INDEX ix_drug_approval_ingredient_concept_id ON drug_approval (ingredient_concept_id);

GO

CREATE TABLE drug_strength (
    ingredient_concept_id INTEGER NOT NULL, 
    valid_start_date DATETIME NOT NULL, 
    concentration_value NUMERIC(38, 0) NULL, 
    valid_end_date DATETIME NOT NULL, 
    amount_unit VARCHAR(60) NULL, 
    invalid_reason VARCHAR(1) NULL, 
    drug_concept_id INTEGER NOT NULL, 
    concentration_denom_unit VARCHAR(60) NULL, 
    concentration_enum_unit VARCHAR(60) NULL, 
    amount_value NUMERIC(38, 0) NULL, 
    CONSTRAINT pk_drug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id, valid_end_date)
);

GO

CREATE INDEX ix_drug_strength_drug_concept_id_ingredient_concept_id_valid_end_date ON drug_strength (drug_concept_id, ingredient_concept_id, valid_end_date);

GO

CREATE TABLE relationship (
    defines_ancestry INTEGER NOT NULL DEFAULT '1', 
    relationship_name VARCHAR(256) NOT NULL, 
    is_hierarchical INTEGER NOT NULL, 
    relationship_id INTEGER NOT NULL, 
    reverse_relationship INTEGER NULL, 
    CONSTRAINT pk_relationship PRIMARY KEY (relationship_id)
);

GO

CREATE INDEX ix_relationship_relationship_id ON relationship (relationship_id);

GO

CREATE TABLE concept (
    vocabulary_id INTEGER NOT NULL, 
    valid_start_date DATETIME NOT NULL, 
    concept_level INTEGER NOT NULL, 
    valid_end_date DATETIME NOT NULL, 
    concept_name VARCHAR(256) NOT NULL, 
    concept_class VARCHAR(60) NOT NULL, 
    invalid_reason VARCHAR(1) NULL, 
    concept_code VARCHAR(40) NOT NULL, 
    concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_concept PRIMARY KEY (concept_id), 
    CONSTRAINT fk_concept_vocabulary_id_vocabulary FOREIGN KEY(vocabulary_id) REFERENCES vocabulary (vocabulary_id)
);

GO

CREATE INDEX ix_concept_concept_id ON concept (concept_id);

GO

CREATE INDEX ix_concept_vocabulary_id ON concept (vocabulary_id);

GO

CREATE TABLE concept_synonym (
    concept_synonym_id INTEGER NOT NULL, 
    concept_synonym_name VARCHAR(1000) NOT NULL, 
    concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_concept_synonym PRIMARY KEY (concept_synonym_id), 
    CONSTRAINT fk_concept_synonym_concept_id_concept FOREIGN KEY(concept_id) REFERENCES concept (concept_id)
);

GO

CREATE INDEX ix_concept_synonym_concept_id ON concept_synonym (concept_id);

GO

CREATE INDEX ix_concept_synonym_concept_synonym_id ON concept_synonym (concept_synonym_id);

GO

CREATE TABLE concept_relationship (
    valid_end_date DATETIME NOT NULL, 
    valid_start_date DATETIME NOT NULL, 
    invalid_reason VARCHAR(1) NULL, 
    concept_id_1 INTEGER NOT NULL, 
    relationship_id INTEGER NOT NULL, 
    concept_id_2 INTEGER NOT NULL, 
    CONSTRAINT pk_concept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id), 
    CONSTRAINT fk_concept_relationship_concept_id_1_concept FOREIGN KEY(concept_id_1) REFERENCES concept (concept_id), 
    CONSTRAINT fk_concept_relationship_concept_id_2_concept FOREIGN KEY(concept_id_2) REFERENCES concept (concept_id), 
    CONSTRAINT fk_concept_relationship_relationship_id_relationship FOREIGN KEY(relationship_id) REFERENCES relationship (relationship_id)
);

GO

CREATE INDEX ix_concept_relationship_concept_id_1 ON concept_relationship (concept_id_1);

GO

CREATE INDEX ix_concept_relationship_concept_id_1_concept_id_2_relationship_id ON concept_relationship (concept_id_1, concept_id_2, relationship_id);

GO

CREATE INDEX ix_concept_relationship_concept_id_2 ON concept_relationship (concept_id_2);

GO

CREATE INDEX ix_concept_relationship_relationship_id ON concept_relationship (relationship_id);

GO

CREATE TABLE source_to_concept_map (
    valid_end_date DATETIME NOT NULL, 
    mapping_type VARCHAR(20) NULL, 
    valid_start_date DATETIME NOT NULL, 
    source_code_description VARCHAR(256) NULL, 
    invalid_reason VARCHAR(1) NULL, 
    primary_map VARCHAR(1) NULL, 
    target_vocabulary_id INTEGER NOT NULL, 
    source_code VARCHAR(40) NOT NULL, 
    source_vocabulary_id INTEGER NOT NULL, 
    target_concept_id INTEGER NOT NULL, 
    CONSTRAINT pk_source_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date), 
    CONSTRAINT fk_source_to_concept_map_source_vocabulary_id_vocabulary FOREIGN KEY(source_vocabulary_id) REFERENCES vocabulary (vocabulary_id), 
    CONSTRAINT fk_source_to_concept_map_target_concept_id_concept FOREIGN KEY(target_concept_id) REFERENCES concept (concept_id), 
    CONSTRAINT fk_source_to_concept_map_target_vocabulary_id_vocabulary FOREIGN KEY(target_vocabulary_id) REFERENCES vocabulary (vocabulary_id)
);

GO

CREATE INDEX ix_source_to_concept_map_source_code ON source_to_concept_map (source_code);

GO

CREATE INDEX ix_source_to_concept_map_source_vocabulary_id ON source_to_concept_map (source_vocabulary_id);

GO

CREATE INDEX ix_source_to_concept_map_source_vocabulary_id_target_concept_id_source_code_valid_end_date ON source_to_concept_map (source_vocabulary_id, target_concept_id, source_code, valid_end_date);

GO

CREATE INDEX ix_source_to_concept_map_target_concept_id ON source_to_concept_map (target_concept_id);

GO

CREATE INDEX ix_source_to_concept_map_target_vocabulary_id ON source_to_concept_map (target_vocabulary_id);

GO

CREATE TABLE concept_ancestor (
    descendant_concept_id INTEGER NOT NULL, 
    min_levels_of_separation NUMERIC(38, 0) NULL, 
    ancestor_concept_id INTEGER NOT NULL, 
    max_levels_of_separation NUMERIC(38, 0) NULL, 
    CONSTRAINT pk_concept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id), 
    CONSTRAINT fk_concept_ancestor_ancestor_concept_id_concept FOREIGN KEY(ancestor_concept_id) REFERENCES concept (concept_id), 
    CONSTRAINT fk_concept_ancestor_descendant_concept_id_concept FOREIGN KEY(descendant_concept_id) REFERENCES concept (concept_id)
);

GO

CREATE INDEX ix_concept_ancestor_ancestor_concept_id ON concept_ancestor (ancestor_concept_id);

GO

CREATE INDEX ix_concept_ancestor_ancestor_concept_id_descendant_concept_id ON concept_ancestor (ancestor_concept_id, descendant_concept_id);

GO

CREATE INDEX ix_concept_ancestor_descendant_concept_id ON concept_ancestor (descendant_concept_id);

GO

INSERT INTO alembic_version (version_num) VALUES ('146969ca84d7');

GO

