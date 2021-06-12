#!/bin/env python3
from flask import Flask

app = Flask(__name__)

@app.route('/')
def todos():
    return "<p>TODO list!</p>"

if __name__ == '__main__':
    # Rock'n'Roll
    app.run(debug = True)
