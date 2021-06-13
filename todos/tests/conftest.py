#!/bin/env python
import pytest

from src.todos import create_app
from src.todos import db as _db
from src.config import TestConfig


@pytest.fixture(scope='session')
def client(request):
    app = create_app(TestConfig)

    # Establish an application context before running the tests.
    ctx = app.app_context()
    ctx.push()

    # Method to stop the app
    def teardown():
        ctx.pop()

    # Add method teardown to finalizer: it will be executed at the end of the tests
    request.addfinalizer(teardown)

    test_client = app.test_client()
    return test_client


@pytest.fixture(scope='session')
def db(client, request):
    # Method to drop the database
    def teardown():
        _db.drop_all()

    _db.client = client
    _db.create_all()

    # Add method teardown to finalizer: it will be executed at the end of the tests
    request.addfinalizer(teardown)
    return _db


@pytest.fixture(scope='function')
def session(db, request):
    # Creates a new database session for the test
    connection = db.engine.connect()
    transaction = connection.begin()

    options = dict(bind=connection, binds={})
    session = db.create_scoped_session(options=options)

    db.session = session

    # Method to remove application session
    def teardown():
        transaction.rollback()
        connection.close()
        session.remove()

    # Add method teardown to finalizer: it will be executed at the end of the tests
    request.addfinalizer(teardown)
    return session


@pytest.fixture(scope='session')
def runner(client):
    return client.test_cli_runner()
