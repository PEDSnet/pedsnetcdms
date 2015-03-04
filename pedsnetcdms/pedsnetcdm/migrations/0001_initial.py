# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CareSite',
            fields=[
                ('place_of_service_source_value', models.CharField(max_length=100, null=True, db_column='place_of_service_source_value')),
                ('place_of_service_concept_id', models.IntegerField(null=True, db_column='place_of_service_concept_id')),
                ('care_site_source_value', models.CharField(max_length=100, db_column='care_site_source_value')),
                ('care_site_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='care_site_id')),
            ],
            options={
                'db_table': 'care_site',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Cohort',
            fields=[
                ('cohort_end_date', models.DateTimeField(null=True, db_column='cohort_end_date')),
                ('cohort_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='cohort_id')),
                ('subject_id', models.IntegerField(db_column='subject_id')),
                ('stop_reason', models.CharField(max_length=100, null=True, db_column='stop_reason')),
                ('cohort_concept_id', models.IntegerField(db_column='cohort_concept_id')),
                ('cohort_start_date', models.DateTimeField(db_column='cohort_start_date')),
            ],
            options={
                'db_table': 'cohort',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ConditionEra',
            fields=[
                ('condition_concept_id', models.IntegerField(db_column='condition_concept_id')),
                ('condition_occurrence_count', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='condition_occurrence_count')),
                ('condition_era_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='condition_era_id')),
                ('condition_type_concept_id', models.IntegerField(db_column='condition_type_concept_id')),
                ('condition_era_start_date', models.DateTimeField(db_column='condition_era_start_date')),
                ('condition_era_end_date', models.DateTimeField(db_column='condition_era_end_date')),
            ],
            options={
                'db_table': 'condition_era',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ConditionOccurrence',
            fields=[
                ('condition_concept_id', models.IntegerField(db_column='condition_concept_id')),
                ('condition_type_concept_id', models.IntegerField(db_column='condition_type_concept_id')),
                ('stop_reason', models.CharField(max_length=100, null=True, db_column='stop_reason')),
                ('condition_start_date', models.DateTimeField(db_column='condition_start_date')),
                ('condition_end_date', models.DateTimeField(null=True, db_column='condition_end_date')),
                ('condition_source_value', models.CharField(max_length=100, null=True, db_column='condition_source_value')),
                ('condition_occurrence_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='condition_occurrence_id')),
            ],
            options={
                'db_table': 'condition_occurrence',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Death',
            fields=[
                ('death_type_concept_id', models.IntegerField(db_column='death_type_concept_id')),
                ('death_date', models.DateTimeField(db_column='death_date')),
                ('cause_of_death_source_value', models.CharField(max_length=100, null=True, db_column='cause_of_death_source_value')),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('cause_of_death_concept_id', models.IntegerField(null=True, db_column='cause_of_death_concept_id')),
            ],
            options={
                'db_table': 'death',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DrugCost',
            fields=[
                ('total_out_of_pocket', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='total_out_of_pocket')),
                ('paid_toward_deductible', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_toward_deductible')),
                ('drug_cost_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='drug_cost_id')),
                ('paid_by_payer', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_by_payer')),
                ('paid_copay', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_copay')),
                ('paid_coinsurance', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_coinsurance')),
                ('paid_by_coordination_benefits', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_by_coordination_benefits')),
                ('average_wholesale_price', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='average_wholesale_price')),
                ('ingredient_cost', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='ingredient_cost')),
                ('total_paid', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='total_paid')),
                ('dispensing_fee', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='dispensing_fee')),
            ],
            options={
                'db_table': 'drug_cost',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DrugEra',
            fields=[
                ('drug_era_end_date', models.DateTimeField(db_column='drug_era_end_date')),
                ('drug_era_start_date', models.DateTimeField(db_column='drug_era_start_date')),
                ('drug_era_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='drug_era_id')),
                ('drug_exposure_count', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='drug_exposure_count')),
                ('drug_type_concept_id', models.IntegerField(db_column='drug_type_concept_id')),
                ('drug_concept_id', models.IntegerField(db_column='drug_concept_id')),
            ],
            options={
                'db_table': 'drug_era',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DrugExposure',
            fields=[
                ('refills', models.DecimalField(null=True, decimal_places=0, max_digits=3, db_column='refills')),
                ('stop_reason', models.CharField(max_length=100, null=True, db_column='stop_reason')),
                ('relevant_condition_concept_id', models.IntegerField(null=True, db_column='relevant_condition_concept_id')),
                ('days_supply', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='days_supply')),
                ('drug_exposure_start_date', models.DateTimeField(db_column='drug_exposure_start_date')),
                ('sig', models.CharField(max_length=500, null=True, db_column='sig')),
                ('drug_exposure_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='drug_exposure_id')),
                ('drug_source_value', models.CharField(max_length=100, null=True, db_column='drug_source_value')),
                ('drug_exposure_end_date', models.DateTimeField(null=True, db_column='drug_exposure_end_date')),
                ('drug_type_concept_id', models.IntegerField(db_column='drug_type_concept_id')),
                ('drug_concept_id', models.IntegerField(db_column='drug_concept_id')),
                ('quantity', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='quantity')),
            ],
            options={
                'db_table': 'drug_exposure',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Location',
            fields=[
                ('city', models.CharField(max_length=50, null=True, db_column='city')),
                ('zip', models.CharField(max_length=9, null=True, db_column='zip')),
                ('county', models.CharField(max_length=50, null=True, db_column='county')),
                ('state', models.CharField(max_length=2, null=True, db_column='state')),
                ('address_1', models.CharField(max_length=100, null=True, db_column='address_1')),
                ('address_2', models.CharField(max_length=100, null=True, db_column='address_2')),
                ('location_source_value', models.CharField(max_length=300, null=True, db_column='location_source_value')),
                ('location_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='location_id')),
            ],
            options={
                'db_table': 'location',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Observation',
            fields=[
                ('range_high', models.DecimalField(null=True, decimal_places=3, max_digits=14, db_column='range_high')),
                ('observation_concept_id', models.IntegerField(db_column='observation_concept_id')),
                ('range_low', models.DecimalField(null=True, decimal_places=3, max_digits=14, db_column='range_low')),
                ('observation_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='observation_id')),
                ('relevant_condition_concept_id', models.IntegerField(null=True, db_column='relevant_condition_concept_id')),
                ('observation_time', models.DateTimeField(null=True, db_column='observation_time')),
                ('unit_concept_id', models.IntegerField(null=True, db_column='unit_concept_id')),
                ('value_as_number', models.DecimalField(null=True, decimal_places=3, max_digits=14, db_column='value_as_number')),
                ('observation_source_value', models.CharField(max_length=100, null=True, db_column='observation_source_value')),
                ('value_as_string', models.CharField(max_length=4000, null=True, db_column='value_as_string')),
                ('observation_type_concept_id', models.IntegerField(db_column='observation_type_concept_id')),
                ('observation_date', models.DateTimeField(db_column='observation_date')),
                ('value_as_concept_id', models.IntegerField(null=True, db_column='value_as_concept_id')),
                ('units_source_value', models.CharField(max_length=100, null=True, db_column='units_source_value')),
            ],
            options={
                'db_table': 'observation',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ObservationPeriod',
            fields=[
                ('observation_period_end_date', models.DateTimeField(null=True, db_column='observation_period_end_date')),
                ('observation_period_start_date', models.DateTimeField(db_column='observation_period_start_date')),
                ('observation_period_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='observation_period_id')),
            ],
            options={
                'db_table': 'observation_period',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Organization',
            fields=[
                ('organization_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='organization_id')),
                ('place_of_service_concept_id', models.IntegerField(null=True, db_column='place_of_service_concept_id')),
                ('place_of_service_source_value', models.CharField(max_length=100, null=True, db_column='place_of_service_source_value')),
                ('organization_source_value', models.CharField(unique=True, max_length=50, db_column='organization_source_value')),
                ('location_id', models.ForeignKey(related_name='organization_location_id_set', db_column='location_id', to='pedsnetcdm.Location', null=True)),
            ],
            options={
                'db_table': 'organization',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PayerPlanPeriod',
            fields=[
                ('plan_source_value', models.CharField(max_length=100, null=True, db_column='plan_source_value')),
                ('family_source_value', models.CharField(max_length=100, null=True, db_column='family_source_value')),
                ('payer_plan_period_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='payer_plan_period_id')),
                ('payer_plan_period_end_date', models.DateTimeField(db_column='payer_plan_period_end_date')),
                ('payer_source_value', models.CharField(max_length=100, null=True, db_column='payer_source_value')),
                ('payer_plan_period_start_date', models.DateTimeField(db_column='payer_plan_period_start_date')),
            ],
            options={
                'db_table': 'payer_plan_period',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Person',
            fields=[
                ('ethnicity_concept_id', models.IntegerField(null=True, db_column='ethnicity_concept_id')),
                ('ethnicity_source_value', models.CharField(max_length=50, null=True, db_column='ethnicity_source_value')),
                ('person_source_value', models.CharField(unique=True, max_length=100, db_column='person_source_value')),
                ('month_of_birth', models.DecimalField(null=True, decimal_places=0, max_digits=2, db_column='month_of_birth')),
                ('pn_time_of_birth', models.DateTimeField(null=True, db_column='pn_time_of_birth')),
                ('day_of_birth', models.DecimalField(null=True, decimal_places=0, max_digits=2, db_column='day_of_birth')),
                ('year_of_birth', models.DecimalField(decimal_places=0, max_digits=4, db_column='year_of_birth')),
                ('gender_source_value', models.CharField(max_length=50, null=True, db_column='gender_source_value')),
                ('race_source_value', models.CharField(max_length=50, null=True, db_column='race_source_value')),
                ('person_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='person_id')),
                ('gender_concept_id', models.IntegerField(db_column='gender_concept_id')),
                ('race_concept_id', models.IntegerField(null=True, db_column='race_concept_id')),
                ('pn_gestational_age', models.DecimalField(null=True, decimal_places=2, max_digits=4, db_column='pn_gestational_age')),
                ('care_site_id', models.ForeignKey(related_name='person_care_site_id_set', db_column='care_site_id', to='pedsnetcdm.CareSite')),
                ('location_id', models.ForeignKey(related_name='person_location_id_set', db_column='location_id', to='pedsnetcdm.Location', null=True)),
            ],
            options={
                'db_table': 'person',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ProcedureCost',
            fields=[
                ('total_out_of_pocket', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='total_out_of_pocket')),
                ('revenue_code_source_value', models.CharField(max_length=100, null=True, db_column='revenue_code_source_value')),
                ('paid_toward_deductible', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_toward_deductible')),
                ('revenue_code_concept_id', models.IntegerField(null=True, db_column='revenue_code_concept_id')),
                ('paid_by_payer', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_by_payer')),
                ('procedure_cost_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='procedure_cost_id')),
                ('paid_copay', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_copay')),
                ('paid_coinsurance', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_coinsurance')),
                ('paid_by_coordination_benefits', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='paid_by_coordination_benefits')),
                ('total_paid', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='total_paid')),
                ('disease_class_concept_id', models.IntegerField(null=True, db_column='disease_class_concept_id')),
                ('disease_class_source_value', models.CharField(max_length=100, null=True, db_column='disease_class_source_value')),
                ('payer_plan_period_id', models.ForeignKey(related_name='procedure_cost_payer_plan_period_id_set', db_column='payer_plan_period_id', to='pedsnetcdm.PayerPlanPeriod', null=True)),
            ],
            options={
                'db_table': 'procedure_cost',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ProcedureOccurrence',
            fields=[
                ('procedure_concept_id', models.IntegerField(db_column='procedure_concept_id')),
                ('relevant_condition_concept_id', models.IntegerField(null=True, db_column='relevant_condition_concept_id')),
                ('procedure_date', models.DateTimeField(db_column='procedure_date')),
                ('procedure_type_concept_id', models.IntegerField(db_column='procedure_type_concept_id')),
                ('procedure_source_value', models.CharField(max_length=100, null=True, db_column='procedure_source_value')),
                ('procedure_occurrence_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='procedure_occurrence_id')),
            ],
            options={
                'db_table': 'procedure_occurrence',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Provider',
            fields=[
                ('provider_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='provider_id')),
                ('npi', models.CharField(max_length=20, null=True, db_column='npi')),
                ('specialty_concept_id', models.IntegerField(null=True, db_column='specialty_concept_id')),
                ('provider_source_value', models.CharField(max_length=100, db_column='provider_source_value')),
                ('dea', models.CharField(max_length=20, null=True, db_column='dea')),
                ('specialty_source_value', models.CharField(max_length=300, null=True, db_column='specialty_source_value')),
                ('care_site_id', models.ForeignKey(related_name='provider_care_site_id_set', db_column='care_site_id', to='pedsnetcdm.CareSite')),
            ],
            options={
                'db_table': 'provider',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='VisitOccurrence',
            fields=[
                ('provider_id', models.IntegerField(null=True, db_column='provider_id')),
                ('place_of_service_concept_id', models.IntegerField(db_column='place_of_service_concept_id')),
                ('visit_start_date', models.DateTimeField(db_column='visit_start_date')),
                ('place_of_service_source_value', models.CharField(max_length=100, null=True, db_column='place_of_service_source_value')),
                ('visit_end_date', models.DateTimeField(null=True, db_column='visit_end_date')),
                ('care_site_id', models.IntegerField(null=True, db_column='care_site_id')),
                ('visit_occurrence_id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='visit_occurrence_id')),
                ('person_id', models.ForeignKey(related_name='visit_occurrence_person_id_set', db_column='person_id', to='pedsnetcdm.Person')),
            ],
            options={
                'db_table': 'visit_occurrence',
            },
            bases=(models.Model,),
        ),
        migrations.AlterIndexTogether(
            name='visitoccurrence',
            index_together=set([('person_id', 'visit_start_date')]),
        ),
        migrations.AddField(
            model_name='procedureoccurrence',
            name='associated_provider_id',
            field=models.ForeignKey(related_name='procedure_occurrence_associated_provider_id_set', db_column='associated_provider_id', to='pedsnetcdm.Provider', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='procedureoccurrence',
            name='person_id',
            field=models.ForeignKey(related_name='procedure_occurrence_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='procedureoccurrence',
            name='visit_occurrence_id',
            field=models.ForeignKey(related_name='procedure_occurrence_visit_occurrence_id_set', db_column='visit_occurrence_id', to='pedsnetcdm.VisitOccurrence', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='procedurecost',
            name='procedure_occurrence_id',
            field=models.ForeignKey(related_name='procedure_cost_procedure_occurrence_id_set', db_column='procedure_occurrence_id', to='pedsnetcdm.ProcedureOccurrence'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='person',
            name='provider_id',
            field=models.ForeignKey(related_name='person_provider_id_set', db_column='provider_id', to='pedsnetcdm.Provider', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='payerplanperiod',
            name='person_id',
            field=models.ForeignKey(related_name='payer_plan_period_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AlterIndexTogether(
            name='organization',
            index_together=set([('organization_source_value', 'place_of_service_source_value')]),
        ),
        migrations.AddField(
            model_name='observationperiod',
            name='person_id',
            field=models.ForeignKey(related_name='observation_period_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AlterIndexTogether(
            name='observationperiod',
            index_together=set([('person_id', 'observation_period_start_date')]),
        ),
        migrations.AddField(
            model_name='observation',
            name='associated_provider_id',
            field=models.ForeignKey(related_name='observation_associated_provider_id_set', db_column='associated_provider_id', to='pedsnetcdm.Provider', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='observation',
            name='person_id',
            field=models.ForeignKey(related_name='observation_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='observation',
            name='visit_occurrence_id',
            field=models.ForeignKey(related_name='observation_visit_occurrence_id_set', db_column='visit_occurrence_id', to='pedsnetcdm.VisitOccurrence', null=True),
            preserve_default=True,
        ),
        migrations.AlterIndexTogether(
            name='observation',
            index_together=set([('person_id', 'observation_concept_id')]),
        ),
        migrations.AddField(
            model_name='drugexposure',
            name='person_id',
            field=models.ForeignKey(related_name='drug_exposure_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='drugexposure',
            name='prescribing_provider_id',
            field=models.ForeignKey(related_name='drug_exposure_prescribing_provider_id_set', db_column='prescribing_provider_id', to='pedsnetcdm.Provider', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='drugexposure',
            name='visit_occurrence_id',
            field=models.ForeignKey(related_name='drug_exposure_visit_occurrence_id_set', db_column='visit_occurrence_id', to='pedsnetcdm.VisitOccurrence', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='drugera',
            name='person_id',
            field=models.ForeignKey(related_name='drug_era_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='drugcost',
            name='drug_exposure_id',
            field=models.ForeignKey(related_name='drug_cost_drug_exposure_id_set', db_column='drug_exposure_id', to='pedsnetcdm.DrugExposure'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='drugcost',
            name='payer_plan_period_id',
            field=models.ForeignKey(related_name='drug_cost_payer_plan_period_id_set', db_column='payer_plan_period_id', to='pedsnetcdm.PayerPlanPeriod', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='death',
            name='person_id',
            field=models.ForeignKey(related_name='death_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='conditionoccurrence',
            name='associated_provider_id',
            field=models.ForeignKey(related_name='condition_occurrence_associated_provider_id_set', db_column='associated_provider_id', to='pedsnetcdm.Provider', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='conditionoccurrence',
            name='person_id',
            field=models.ForeignKey(related_name='condition_occurrence_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='conditionoccurrence',
            name='visit_occurrence_id',
            field=models.ForeignKey(related_name='condition_occurrence_visit_occurrence_id_set', db_column='visit_occurrence_id', to='pedsnetcdm.VisitOccurrence', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='conditionera',
            name='person_id',
            field=models.ForeignKey(related_name='condition_era_person_id_set', db_column='person_id', to='pedsnetcdm.Person'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='caresite',
            name='location_id',
            field=models.ForeignKey(related_name='care_site_location_id_set', db_column='location_id', to='pedsnetcdm.Location', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='caresite',
            name='organization_id',
            field=models.ForeignKey(related_name='care_site_organization_id_set', db_column='organization_id', to='pedsnetcdm.Organization'),
            preserve_default=True,
        ),
        migrations.AlterUniqueTogether(
            name='caresite',
            unique_together=set([('organization_id', 'care_site_source_value')]),
        ),
    ]
