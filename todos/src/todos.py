#!/bin/env python
from flask import Flask, render_template, request

app = Flask(__name__)

todo_list = []

def get_todo_list():
    return todo_list

@app.route('/', methods=['GET', 'POST'])
def todos():
    if request.method == 'POST':
        todo_list.append(request.form['todo'])
    return render_template('base.html', todos=get_todo_list())

def create_app(test_config=None):
    return app

if __name__ == '__main__':
    # Rock'n'Roll
    app.run(debug = True)
