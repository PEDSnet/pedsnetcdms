import json
from pkg_resources import resource_string
from django.db.models import Model
from pedsnetcdms.dj_makers import make_models

DECLARATIVE_MODELS = json.loads(resource_string('pedsnetcdms.pedsnetcdm',
                                                'models.json'))

for model in make_models(DECLARATIVE_MODELS, (Model,),
                         'pedsnetcdms.pedsnetcdm.models', 'pedsnetcdm'):
    globals()[model.__name__] = model
