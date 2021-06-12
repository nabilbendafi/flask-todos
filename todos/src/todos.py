#!/bin/env python
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def todos():
    if request.method == 'POST':
        app.logger.debug(request)
        app.logger.debug(request.form)
    return render_template('base.html')

def create_app(test_config=None):
    return app

if __name__ == '__main__':
    # Rock'n'Roll
    app.run(debug = True)
