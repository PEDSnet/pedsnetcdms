from __future__ import unicode_literals

from datetime import datetime
from django.db.models import (AutoField, IntegerField, DecimalField, CharField,
                              DateField, DateTimeField, ForeignKey, TextField)

DATATYPE_MAP = {
    'auto': AutoField,
    'integer': IntegerField,
    'numeric': DecimalField,
    'string': CharField,
    'date': DateField,
    'datetime': DateTimeField,
    'text': TextField
}

DATATYPE_BEHAVIOR_MAP = {
    'precision': 'max_digits',
    'scale': 'decimal_places',
    'length': 'max_length'
}


def _make_column(name, column):
    """Returns a dynamically constructed Django model Field class.

    `column` is a declarative style dictionary column object. Many examples
    are available in the models.josn file (although some preprocessing is
    required to produce the intended Field classes from those examples, a
    task typically handed through the `_make_model` function).
    """

    args = []

    # Transform declarative datatype behavior kwargs to Django-style.

    kwargs = {DATATYPE_BEHAVIOR_MAP.get(k, k): v for k, v in
              column.get('datatype_behavior', {}).items()}

    # Column and datatype behavior kwargs all go in the Field constructor.

    kwargs.update(column.get('column_behavior', {}))

    # Set the db_column kwarg to avoid Django's annoying '_id' suffix.

    kwargs['db_column'] = name

    # Set null kwarg, defaulting to False for primary keys and True for others.

    if kwargs.get('primary_key', False):
        nullable = kwargs.pop('nullable', False)
    else:
        nullable = kwargs.pop('nullable', True)

    if nullable:
        kwargs['null'] = True

    # Determine correct Field constructor.

    datatype = DATATYPE_MAP[column['datatype']]

    # If autoincrement set to True, or not set to False and primary_key is set
    # to True, use an AutoField.

    if kwargs.get('autoincrement', False):
        datatype = AutoField

    if kwargs.pop('autoincrement', True) and kwargs.get('primary_key', False):
        datatype = AutoField

    # Use the foreign_key_to kwarg added by the model constructor.

    foreign_key_to = kwargs.pop('foreign_key_to', None)

    if foreign_key_to:

        datatype = ForeignKey

        # Add foreign key target model to args.

        args.append(foreign_key_to)

    # Create choices iterable of tuples.

    if 'choices' in kwargs:
        kwargs['choices'] = [(choice, choice) for choice in kwargs['choices']]

    # Handle datetime "now" default.

    if kwargs.get('default', '') == 'now':
        kwargs['default'] == datetime.now

    # Return the Field instance.

    return datatype(*args, **kwargs)


def _make_meta(name, model):
    """Returns a dynamically constructed Django model Meta class.

    `name` is an underscore style model name.

    `model` is a declarative style nested dictionary model object. Many
    examples are available in the models.json files (although valid Meta
    class production from those examples requires some preprocessing, a
    task typically handled through the `_make_model` function).
    """

    class_contents = {'db_table': name,
                      'app_label': model['app_label']}

    # Create table level indexes argument.

    if 'indexes' in model:

        indexes = [index['columns'] for index in model['indexes']]
        class_contents.update({'index_together': indexes})

    # Create table level uniques argument.

    if 'uniques' in model:

        uniques = tuple(tuple(unique['columns'])
                        for unique in model['uniques'])
        class_contents.update({'unique_together': uniques})

    # Return a dynamically constructed Meta class.

    return type(str('Meta'), (), class_contents)


def _make_model(name, model, bases):
    """Returns a dynamically constructed Django model class.

    `name` is an underscore style model name.

    `model` is a declarative style nested dictionary model object. Many
    examples are available in the models.json file (although those examples
    would need to have `module` and `app_label` attributes added, a task
    typically handled through the `make_models` wrapper function).

    `bases` is a tuple of base classes the produced model should inherit from.
    This could simply be (django.db.models.Model,).
    """

    class_name = ''.join(i.capitalize() for i in name.split('_'))

    class_contents = {'__module__': model['module']}

    # Create single column integer primary key if not defined.

    if 'primary_key' not in model or len(model['primary_key']['columns']) > 1:

        model['columns']['id'] = {'datatype': 'integer', 'column_behavior': {
            'primary_key': True, 'db_index': True}}

    # Convert multi-column primary key into unique constraint and add single
    # column integer primary key.

    elif len(model['primary_key']['columns']) > 1:

        model['uniques'] = model.get('uniques', [])
        model['uniques'].append({'columns': model['primary_key']['columns']})

    # Add primary_key and db_index to the appropriate column's column_behavior.

    else:

        pkey_column = model['columns'][model['primary_key']['columns'][0]]
        pkey_column['column_behavior'] = pkey_column.get('column_behavior', {})
        pkey_column['column_behavior'].update({'primary_key': True,
                                               'db_index': True})

    # Move single column indexes to the named column, as Django expects.

    for index in [index for index in model.get('indexes', [])
                  if len(index['columns']) == 1]:

        idx_column = model['columns'][index['columns'][0]]
        idx_column['column_behavior'] = idx_column.get('column_behavior', {})
        idx_column['column_behavior'].update({'db_index': True})

    model['indexes'] = [index for index in model.get('indexes', [])
                        if len(index['columns']) > 1]

    # Move foreign keys to the named column, as Django expects.

    for foreign_key in model.get('foreign_keys', []):

        to_name = foreign_key['to'].split('.')[0]
        to_class = ''.join(i.capitalize() for i in to_name.split('_'))

        fkey_column = model['columns'][foreign_key['from']]

        fkey_column['column_behavior'] = fkey_column.get('column_behavior', {})
        fkey_column['column_behavior'].update({'foreign_key_to': to_class})

        # Set related_name if more than one foreign key to the same model
        # exists.

        if to_name in [fkey['to'].split('.')[0]
                       for fkey in model['foreign_keys']]:
            fkey_column['column_behavior'].\
                update({'related_name': '{0}_{1}_set'.
                        format(name, foreign_key['from'])})

    # Create and add the Meta class.

    class_contents.update({'Meta': _make_meta(name, model)})

    # Add columns to the class.

    for name, column in model['columns'].iteritems():
        class_contents.update({name: _make_column(name, column)})

    # Return a dynamically constructed model class.

    return type(str(class_name), bases, class_contents)


def make_models(models, bases, module, app_label):
    """Returns a list of dynamically constructed Django model classes.

    `models` is a dict of declarative style nested dictionary model objects.
    Many examples are available in the models.json file.

    `bases` is a tuple of base classes the produced models should inherit from.
    This could simply be (django.db.models.Model,).

    `module` is the dot separated string path of the module within which the
    models will reside. It is required by the Django model constructor.

    `app_label` is the string `app_label`, which will be included in the
    models' Meta classes. It is useful for associating the models with a
    particular Django app.
    """

    output_models = []

    for name, model in models.iteritems():

        # Add Django-required module and app_label.

        model.update({'module': module, 'app_label': app_label})

        # Add the dynamically constructed class to the module namespace.

        output_models.append(_make_model(name, model, bases))

    return output_models
