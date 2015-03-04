import sys
from setuptools import setup, find_packages

if sys.version_info < (2, 7):
    raise EnvironmentError('Python 2.7.x is required')

with open('README.md', 'r') as f:
    long_description = f.read()

package_data = {
    'pedsnetcdms': [
        'pedsnetcdm/models.json',
        'vocabcdm/models.json',
        'itwobtwocdm/models.json',
        'pcornetcdm/models.json'
    ]
}

install_requires = [
    'Django==1.7.5',
    'SQLAlchemy==0.9.8',
    'alembic==0.7.4'
]

kwargs = {
    'name': 'pedsnetcdms',
    'version': '0.1',
    'author': 'The Children\'s Hospital of Philadelphia',
    'author_email': 'cbmisupport@email.chop.edu',
    'url': 'https://github.com/PEDSnet/Data_Models',
    'description': 'PEDSnet Common Data Model Definitions',
    'long_description': long_description,
    'packages': find_packages(),
    'package_data': package_data,
    'install_requires': install_requires,
    'download_url': 'https://github.com/PEDSnet/pedsnetcdms/tarball/0.1',
}

setup(**kwargs)
