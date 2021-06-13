import os


class Config(object):
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    # Use variable environment DATABASE_URI as database URL by default
    if 'DATABASE_URI' in os.environ:
        SQLALCHEMY_DATABASE_URI = os.environ['DATABASE_URI']


class TestConfig(Config):
    TESTING = True
    # Use sqlite as database for testing environment
    SQLALCHEMY_DATABASE_URI = 'sqlite:///testdb.sqlite'
