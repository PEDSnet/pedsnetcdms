from __future__ import unicode_literals

from sqlalchemy import Column, Integer, Numeric, String, Date, DateTime, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.ext.compiler import compiles
from sqlalchemy.sql.expression import text
from sqlalchemy.schema import (PrimaryKeyConstraint, ForeignKeyConstraint,
                               Index, CheckConstraint, UniqueConstraint)

DATATYPE_MAP = {
    'integer': Integer,
    'numeric': Numeric,
    'string': String,
    'date': Date,
    'datetime': DateTime,
    'text': Text
}


def _all_constraint_names(constraint, table):
    name_list = [table.name]
    name_list.extend([c.name for c in constraint.columns.values()])
    return '_'.join(name_list)

NAMING_CONVENTION = {
    'all_constraint_names': _all_constraint_names,
    'ix': 'ix_%(all_constraint_names)s',
    'uq': 'uq_%(all_constraint_names)s',
    'ck': 'ck_%(table_name)s_%(constraint_name)s',
    'fk': 'fk_%(table_name)s_%(column_0_name)s_%(referred_table_name)s',
    'pk': 'pk_%(table_name)s'
}

Base = declarative_base()
Base.metadata.naming_convention = NAMING_CONVENTION


# Coerce Numeric type to produce NUMBER on Oracle backend.
@compiles(Numeric, 'oracle')
def _compile_numeric_oracle(type_, compiler, **kw):
    return 'NUMBER'


# and Integer type to produce NUMBER(10) on Oracle backend.
@compiles(Integer, 'oracle')
def _compile_integer_oracle(type_, compiler, **kw):
    return 'NUMBER(10)'


# Add DEFERRABLE INITIALLY DEFERRED to Oracle constraints.
@compiles(ForeignKeyConstraint, 'oracle')
@compiles(PrimaryKeyConstraint, 'oracle')
@compiles(UniqueConstraint, 'oracle')
@compiles(CheckConstraint, 'oracle')
def _compile_constraint_oracle(constraint, compiler, **kw):

    constraint.deferrable = True
    constraint.initially = 'DEFERRED'
    visit_attr = 'visit_{0}'.format(constraint.__visit_name__)
    return getattr(compiler, visit_attr)(constraint, **kw)


# Add DEFERRABLE INITIALLY DEFERRED to PostgreSQL constraints.
@compiles(ForeignKeyConstraint, 'postgresql')
@compiles(PrimaryKeyConstraint, 'postgresql')
@compiles(UniqueConstraint, 'postgresql')
@compiles(CheckConstraint, 'postgresql')
def _compile_constraint_postgresql(constraint, compiler, **kw):

    constraint.deferrable = True
    constraint.initially = 'DEFERRED'
    visit_attr = 'visit_{0}'.format(constraint.__visit_name__)
    return getattr(compiler, visit_attr)(constraint, **kw)


def _make_column(name, column):
    """Returns a dynamically constructed SQLAlchemy model Column class.

    `column` is a declarative style dictionary column object. Many examples
    are available in the models.json files.
    """

    args = [name]
    kwargs = column.get('column_behavior', {})

    # Create a datatype instance.

    if column['datatype'] == 'integer':
        datatype = Integer()

    else:
        datatype_kwargs = column.get('datatype_behavior', {})
        datatype = DATATYPE_MAP[column['datatype']](**datatype_kwargs)

    args.append(datatype)

    # Create the server_default kwarg, which takes a string value.

    default = kwargs.pop('default', None)

    if isinstance(default, int):
        kwargs['server_default'] = str(default)

    elif isinstance(default, str):
        kwargs['server_default'] = default
        if default == 'now':
            kwargs['server_default'] = text('CURRENT_TIMESTAMP(0)')

    # Create a CheckConstraint to enforce choices.

    choices = kwargs.pop('choices', None)
    if choices:
        constraint_string = '{0} IN {1}'.format(name, choices)
        constraint_name = '{0}_in_{1}'.format(name, '_'.join(choices))
        args.append(CheckConstraint(constraint_string, name=constraint_name))

    # Return the Column instance.

    return Column(*args, **kwargs)


def _make_primary_key(primary_key):
    """Returns a dynamically constructed SQLAlchemy PrimaryKeyConstraint.

    `primary_key` is a declarative style dictionary primary key constraint
    object. Many examples are available in the models.json files.
    """

    args = primary_key['columns']
    kwargs = {}

    return PrimaryKeyConstraint(*args, **kwargs)


def _make_foreign_key(foreign_key):
    """Returns a dynamically constructed SQLAlchemy ForeignKeyConstraint.

    `foreign_key` is a declarative style dictionary foreign key constraint
    object. Many examples are available in the models.json files.
    """

    args = [[foreign_key['from']], [foreign_key['to']]]
    kwargs = {}

    return ForeignKeyConstraint(*args, **kwargs)


def _make_index(model, index):
    """Returns a dynamically constructed SQLAlchemy Index.

    `model` is a declarative style nested dictionary model object. Many
    examples are available in the models.json files.

    `index` is a declarative style dictionary index object. Many examples are
    available in the models.json files.
    """

    # Use None in the name arg slot to auto-generate a name.
    args = [None]
    args.extend(index['columns'])
    kwargs = {'postgresql_ops': {}}
    kwargs['unique'] = index.get('unique', False)

    # Add varchar pattern ops class to PostgreSQL indexes.
    for column in index['columns']:
        datatype = model['columns'][column]['datatype']
        if datatype == 'string':
            kwargs['postgresql_ops'][column] = 'varchar_pattern_ops'

    return Index(*args, **kwargs)


def _make_unique(unique):
    """Returns a dynamically constructed SQLAlchemy UniqueConstraint.

    `unique` is a declarative style dictionary unique constraint object. Many
    examples are available in the models.json files.
    """

    args = unique['columns']

    return UniqueConstraint(*args)


def _make_model(name, model, bases):
    """Returns a dynamically constructed SQLAlchemy model class.

    `name` is an underscore style model name.

    `model` is a declarative style nested dictionary model object. Many
    examples are available in the models.json files.

    `bases` is a tuple of base classes the produced model should inherit from.
    This could simply be (sqlalchemy.ext.declarative.declarative_base(),).
    """

    class_name = ''.join(i.capitalize() for i in name.split('_'))
    class_contents = {'__tablename__': name}
    table_args = []

    # Build a list of table-level behavior arguments.

    if 'primary_key' not in model:

        model['primary_key'] = {'columns': ['id']}
        model['columns']['id'] = {'datatype': 'integer'}

    table_args.append(_make_primary_key(model['primary_key']))
    # Add an index for the primary key as well.
    table_args.append(_make_index(model, model['primary_key']))

    for foreign_key in model.get('foreign_keys', []):
        table_args.append(_make_foreign_key(foreign_key))

        # Add an index for the foreign key as well.
        foreign_key['columns'] = [foreign_key['from']]
        table_args.append(_make_index(model, foreign_key))

    for index in model.get('indexes', []):
        table_args.append(_make_index(model, index))

    for unique in model.get('uniques', []):
        table_args.append(_make_unique(unique))

    # Add __table_args__, which must be a tuple, to the class.

    class_contents.update({'__table_args__': tuple(table_args)})

    # Add columns to the class.

    for name, column in model['columns'].iteritems():
        class_contents.update({name: _make_column(name, column)})

    # Return a dynamically constructed model class.

    return type(str(class_name), bases, class_contents)


def make_models(models, bases):
    """Returns a list of dynamically constructed SQLAlchemy model classes.

    `models` is a dict of declarative style nested dictionary model objects.
    Many examples are available in the models.json files.

    `bases` is a tuple of base classes the produced models should inherit from.
    This could simply be (sqlalchemy.ext.declarative.declarative_base(),).
    """

    output_models = []

    for name, model in models.iteritems():

        # Add the dynamically constructed class to the module namespace.

        output_models.append(_make_model(name, model, bases))

    return output_models
