#!/bin/env python
import pytest

from src.todos import create_app

@pytest.fixture(scope='session')
def client(request):
    app = create_app()

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

@pytest.fixture
def runner(app):
    return app.test_cli_runner()
