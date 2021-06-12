#!/bin/env python
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def todos():
    return render_template('base.html')

def create_app(test_config=None):
    return app

if __name__ == '__main__':
    # Rock'n'Roll
    app.run(debug = True)
