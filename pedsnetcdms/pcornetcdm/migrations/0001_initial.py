# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Demographic',
            fields=[
                ('raw_hispanic', models.CharField(max_length=1028, null=True, db_column='raw_hispanic')),
                ('raw_sex', models.CharField(max_length=1028, null=True, db_column='raw_sex')),
                ('raw_race', models.CharField(max_length=1028, null=True, db_column='raw_race')),
                ('sex', models.CharField(max_length=2, null=True, db_column='sex')),
                ('hispanic', models.CharField(max_length=2, null=True, db_column='hispanic')),
                ('race', models.CharField(max_length=2, null=True, db_column='race')),
                ('patid', models.AutoField(primary_key=True, db_column='patid', serialize=False, max_length=1028, db_index=True)),
                ('birth_date', models.CharField(max_length=10, null=True, db_column='birth_date')),
                ('biobank_flag', models.CharField(max_length=1, null=True, db_column='biobank_flag')),
                ('birth_time', models.CharField(max_length=5, null=True, db_column='birth_time')),
            ],
            options={
                'db_table': 'demographic',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Diagnosis',
            fields=[
                ('raw_dx', models.CharField(max_length=1028, null=True, db_column='raw_dx')),
                ('pdx', models.CharField(max_length=2, null=True, db_column='pdx')),
                ('raw_dx_source', models.CharField(max_length=1028, null=True, db_column='raw_dx_source')),
                ('encounterid', models.CharField(max_length=1028, null=True, db_column='encounterid')),
                ('dx_type', models.CharField(max_length=2, null=True, db_column='dx_type')),
                ('enc_type', models.CharField(max_length=2, null=True, db_column='enc_type')),
                ('raw_pdx', models.CharField(max_length=1028, null=True, db_column='raw_pdx')),
                ('providerid', models.CharField(max_length=1028, null=True, db_column='providerid')),
                ('raw_dx_type', models.CharField(max_length=1028, null=True, db_column='raw_dx_type')),
                ('admit_date', models.CharField(max_length=10, null=True, db_column='admit_date')),
                ('patid', models.CharField(max_length=1028, null=True, db_column='patid')),
                ('dx', models.CharField(max_length=18, null=True, db_column='dx')),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('dx_source', models.CharField(max_length=2, null=True, db_column='dx_source')),
            ],
            options={
                'db_table': 'diagnosis',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Encounter',
            fields=[
                ('admitting_source', models.CharField(max_length=2, null=True, db_column='admitting_source')),
                ('discharge_disposition', models.CharField(max_length=2, null=True, db_column='discharge_disposition')),
                ('facilityid', models.CharField(max_length=1028, null=True, db_column='facilityid')),
                ('raw_enc_type', models.CharField(max_length=1028, null=True, db_column='raw_enc_type')),
                ('discharge_date', models.CharField(max_length=10, null=True, db_column='discharge_date')),
                ('admit_time', models.CharField(max_length=5, null=True, db_column='admit_time')),
                ('discharge_time', models.CharField(max_length=5, null=True, db_column='discharge_time')),
                ('encounterid', models.CharField(max_length=1028, null=True, db_column='encounterid')),
                ('raw_discharge_disposition', models.CharField(max_length=1028, null=True, db_column='raw_discharge_disposition')),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('enc_type', models.CharField(max_length=2, null=True, db_column='enc_type')),
                ('raw_discharge_status', models.CharField(max_length=1028, null=True, db_column='raw_discharge_status')),
                ('drg', models.CharField(max_length=3, null=True, db_column='drg')),
                ('providerid', models.CharField(max_length=1028, null=True, db_column='providerid')),
                ('admit_date', models.CharField(max_length=10, null=True, db_column='admit_date')),
                ('patid', models.CharField(max_length=1028, null=True, db_column='patid')),
                ('drg_type', models.CharField(max_length=2, null=True, db_column='drg_type')),
                ('raw_admitting_source', models.CharField(max_length=1028, null=True, db_column='raw_admitting_source')),
                ('discharge_status', models.CharField(max_length=2, null=True, db_column='discharge_status')),
                ('facility_location', models.CharField(max_length=3, null=True, db_column='facility_location')),
                ('raw_drg_type', models.CharField(max_length=1028, null=True, db_column='raw_drg_type')),
            ],
            options={
                'db_table': 'encounter',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Enrollment',
            fields=[
                ('chart', models.CharField(max_length=1, null=True, db_column='chart')),
                ('enr_end_date', models.CharField(max_length=10, null=True, db_column='enr_end_date')),
                ('enr_start_date', models.CharField(max_length=10, null=True, db_column='enr_start_date')),
                ('patid', models.CharField(max_length=1028, null=True, db_column='patid')),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('enr_basis', models.CharField(max_length=1, null=True, db_column='enr_basis')),
            ],
            options={
                'db_table': 'enrollment',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Procedure',
            fields=[
                ('px', models.CharField(max_length=18, null=True, db_column='px')),
                ('encounterid', models.CharField(max_length=1028, null=True, db_column='encounterid')),
                ('enc_type', models.CharField(max_length=2, null=True, db_column='enc_type')),
                ('providerid', models.CharField(max_length=1028, null=True, db_column='providerid')),
                ('admit_date', models.CharField(max_length=10, null=True, db_column='admit_date')),
                ('patid', models.CharField(max_length=1028, null=True, db_column='patid')),
                ('raw_px_type', models.CharField(max_length=1028, null=True, db_column='raw_px_type')),
                ('px_type', models.CharField(max_length=2, null=True, db_column='px_type')),
                ('id', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='id')),
                ('raw_px', models.CharField(max_length=1028, null=True, db_column='raw_px')),
            ],
            options={
                'db_table': 'procedure',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Vital',
            fields=[
                ('vitalid', models.AutoField(db_index=True, serialize=False, primary_key=True, db_column='vitalid')),
                ('original_bmi', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='original_bmi')),
                ('measure_date', models.CharField(max_length=10, null=True, db_column='measure_date')),
                ('measure_time', models.CharField(max_length=5, null=True, db_column='measure_time')),
                ('encounterid', models.CharField(max_length=1028, null=True, db_column='encounterid')),
                ('ht', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='ht')),
                ('raw_diastolic', models.CharField(max_length=1028, null=True, db_column='raw_diastolic')),
                ('wt', models.DecimalField(null=True, decimal_places=2, max_digits=8, db_column='wt')),
                ('systolic', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='systolic')),
                ('patid', models.CharField(max_length=1028, null=True, db_column='patid')),
                ('bp_position', models.CharField(max_length=2, null=True, db_column='bp_position')),
                ('raw_bp_position', models.CharField(max_length=1028, null=True, db_column='raw_bp_position')),
                ('vital_source', models.CharField(max_length=2, null=True, db_column='vital_source')),
                ('raw_vital_source', models.CharField(max_length=1028, null=True, db_column='raw_vital_source')),
                ('raw_systolic', models.CharField(max_length=1028, null=True, db_column='raw_systolic')),
                ('diastolic', models.DecimalField(null=True, decimal_places=0, max_digits=4, db_column='diastolic')),
            ],
            options={
                'db_table': 'vital',
            },
            bases=(models.Model,),
        ),
    ]
