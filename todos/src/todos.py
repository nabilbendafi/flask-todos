#!/bin/env python
from flask import Flask, render_template, request
from flask_sqlalchemy import SQLAlchemy

from src import Config

app = Flask(__name__)
db = SQLAlchemy()


def get_todo_list():
    return Todo.query.all()


class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)


@app.route('/', methods=['GET', 'POST'])
def todos():
    if request.method == 'POST':
        # Get todo from HTML form
        todo = request.form.get('todo')

        # Update DB
        todo = Todo(name=todo)
        db.session.add(todo)
        db.session.commit()
    return render_template('base.html', todos=get_todo_list())


def create_app(config=Config):
    app.config.from_object(config)

    app.app_context().push()

    db.init_app(app)

    return app


if __name__ == '__main__':
    # Rock'n'Roll
    app = create_app()

    db.init_app(app)
    db.create_all()

    app.run(host='0.0.0.0')
