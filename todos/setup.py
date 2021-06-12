from setuptools import find_packages, setup

from version import __version__

setup(
    name='Todos',
    version=__version__,
    author='Nabil BENDAFI',
    author_email='nabil@bendafi.fr',
    url='https://github.com/nabilbendafi/flask-todos/',
    license='Closed Source',
    description='Flask application that implements a very simple todo list',
    packages=find_packages('src'),
    include_package_data=True,
    install_requires=[
        'flask',
        'setuptools',
        'flasgger'
    ],
    extras_require={
        'test': [
            'pycobertura',
            'pytest',
            'pytest-cov',
            'pytest-mock',
        ],
    },
    zip_safe=False,
)
