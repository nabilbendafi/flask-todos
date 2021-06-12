#!/bin/env python
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)
db = SQLAlchemy(app)

todo_list = []
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


def get_todo_list():
    return todo_list


class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)


@app.route('/', methods=['GET', 'POST'])
def todos():
    if request.method == 'POST':
        todo_list.append(request.form['todo'])
    return render_template('base.html', todos=get_todo_list())


def create_app(test_config=None):
    return app


if __name__ == '__main__':
    # Rock'n'Roll
    db.create_all()
    app.run(debug=True)
