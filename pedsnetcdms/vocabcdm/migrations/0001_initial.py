# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Concept',
            fields=[
                ('valid_start_date', models.DateField(db_column='valid_start_date')),
                ('concept_level', models.IntegerField(db_column='concept_level')),
                ('valid_end_date', models.DateField(default='2099-12-31', db_column='valid_end_date')),
                ('concept_name', models.CharField(max_length=256, db_column='concept_name')),
                ('concept_class', models.CharField(max_length=60, db_column='concept_class')),
                ('invalid_reason', models.CharField(max_length=1, null=True, db_column='invalid_reason', choices=[('D', 'D'), ('U', 'U')])),
                ('concept_code', models.CharField(max_length=40, db_column='concept_code')),
                ('concept_id', models.IntegerField(serialize=False, primary_key=True, db_column='concept_id', db_index=True)),
            ],
            options={
                'db_table': 'concept',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ConceptAncestor',
            fields=[
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('min_levels_of_separation', models.DecimalField(null=True, decimal_places=0, max_digits=38, db_column='min_levels_of_separation')),
                ('max_levels_of_separation', models.DecimalField(null=True, decimal_places=0, max_digits=38, db_column='max_levels_of_separation')),
                ('ancestor_concept_id', models.ForeignKey(related_name='concept_ancestor_ancestor_concept_id_set', db_column='ancestor_concept_id', to='vocabcdm.Concept')),
                ('descendant_concept_id', models.ForeignKey(related_name='concept_ancestor_descendant_concept_id_set', db_column='descendant_concept_id', to='vocabcdm.Concept')),
            ],
            options={
                'db_table': 'concept_ancestor',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ConceptRelationship',
            fields=[
                ('valid_end_date', models.DateField(default='2099-12-31', db_column='valid_end_date')),
                ('valid_start_date', models.DateField(db_column='valid_start_date')),
                ('invalid_reason', models.CharField(max_length=1, null=True, db_column='invalid_reason', choices=[('D', 'D'), ('U', 'U')])),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('concept_id_1', models.ForeignKey(related_name='concept_relationship_concept_id_1_set', db_column='concept_id_1', to='vocabcdm.Concept')),
                ('concept_id_2', models.ForeignKey(related_name='concept_relationship_concept_id_2_set', db_column='concept_id_2', to='vocabcdm.Concept')),
            ],
            options={
                'db_table': 'concept_relationship',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ConceptSynonym',
            fields=[
                ('concept_synonym_id', models.IntegerField(serialize=False, primary_key=True, db_column='concept_synonym_id', db_index=True)),
                ('concept_synonym_name', models.CharField(max_length=1000, db_column='concept_synonym_name')),
                ('concept_id', models.ForeignKey(related_name='concept_synonym_concept_id_set', db_column='concept_id', to='vocabcdm.Concept')),
            ],
            options={
                'db_table': 'concept_synonym',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DrugApproval',
            fields=[
                ('ingredient_concept_id', models.IntegerField(serialize=False, primary_key=True, db_column='ingredient_concept_id', db_index=True)),
                ('approved_by', models.CharField(default='FDA', max_length=20, db_column='approved_by')),
                ('approval_date', models.DateField(db_column='approval_date')),
            ],
            options={
                'db_table': 'drug_approval',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DrugStrength',
            fields=[
                ('ingredient_concept_id', models.IntegerField(db_column='ingredient_concept_id')),
                ('valid_start_date', models.DateField(db_column='valid_start_date')),
                ('concentration_value', models.DecimalField(null=True, decimal_places=0, max_digits=38, db_column='concentration_value')),
                ('valid_end_date', models.DateField(db_column='valid_end_date')),
                ('amount_unit', models.CharField(max_length=60, null=True, db_column='amount_unit')),
                ('invalid_reason', models.CharField(max_length=1, null=True, db_column='invalid_reason', choices=[('D', 'D'), ('U', 'U')])),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('drug_concept_id', models.IntegerField(db_column='drug_concept_id')),
                ('concentration_denom_unit', models.CharField(max_length=60, null=True, db_column='concentration_denom_unit')),
                ('concentration_enum_unit', models.CharField(max_length=60, null=True, db_column='concentration_enum_unit')),
                ('amount_value', models.DecimalField(null=True, decimal_places=0, max_digits=38, db_column='amount_value')),
            ],
            options={
                'db_table': 'drug_strength',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Relationship',
            fields=[
                ('defines_ancestry', models.IntegerField(default=1, db_column='defines_ancestry')),
                ('relationship_name', models.CharField(max_length=256, db_column='relationship_name')),
                ('is_hierarchical', models.IntegerField(db_column='is_hierarchical')),
                ('relationship_id', models.IntegerField(serialize=False, primary_key=True, db_column='relationship_id', db_index=True)),
                ('reverse_relationship', models.IntegerField(null=True, db_column='reverse_relationship')),
            ],
            options={
                'db_table': 'relationship',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SourceToConceptMap',
            fields=[
                ('valid_end_date', models.DateField(default='2099-12-31', db_column='valid_end_date')),
                ('mapping_type', models.CharField(max_length=20, null=True, db_column='mapping_type')),
                ('valid_start_date', models.DateField(db_column='valid_start_date')),
                ('source_code_description', models.CharField(max_length=256, null=True, db_column='source_code_description')),
                ('invalid_reason', models.CharField(max_length=1, null=True, db_column='invalid_reason', choices=[('D', 'D'), ('U', 'U')])),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('primary_map', models.CharField(max_length=1, null=True, db_column='primary_map', choices=[('Y', 'Y')])),
                ('source_code', models.CharField(max_length=40, db_column='source_code', db_index=True)),
            ],
            options={
                'db_table': 'source_to_concept_map',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Vocabulary',
            fields=[
                ('vocabulary_id', models.IntegerField(serialize=False, primary_key=True, db_column='vocabulary_id', db_index=True)),
                ('vocabulary_name', models.CharField(unique=True, max_length=256, db_column='vocabulary_name')),
            ],
            options={
                'db_table': 'vocabulary',
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='sourcetoconceptmap',
            name='source_vocabulary_id',
            field=models.ForeignKey(related_name='source_to_concept_map_source_vocabulary_id_set', db_column='source_vocabulary_id', to='vocabcdm.Vocabulary'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='sourcetoconceptmap',
            name='target_concept_id',
            field=models.ForeignKey(related_name='source_to_concept_map_target_concept_id_set', db_column='target_concept_id', to='vocabcdm.Concept'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='sourcetoconceptmap',
            name='target_vocabulary_id',
            field=models.ForeignKey(related_name='source_to_concept_map_target_vocabulary_id_set', db_column='target_vocabulary_id', to='vocabcdm.Vocabulary'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='conceptrelationship',
            name='relationship_id',
            field=models.ForeignKey(related_name='concept_relationship_relationship_id_set', db_column='relationship_id', to='vocabcdm.Relationship'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='concept',
            name='vocabulary_id',
            field=models.ForeignKey(related_name='concept_vocabulary_id_set', db_column='vocabulary_id', to='vocabcdm.Vocabulary'),
            preserve_default=True,
        ),
    ]
