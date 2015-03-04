import json
from pkg_resources import resource_string
from pedsnetcdms.sa_makers import make_models, Base

DECLARATIVE_MODELS = json.loads(resource_string('pedsnetcdms.itwobtwocdm',
                                                'models.json'))

for model in make_models(DECLARATIVE_MODELS, (Base,)):
    globals()[model.__name__] = model
