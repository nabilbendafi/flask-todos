FROM python:alpine3.7

WORKDIR /todos
COPY . /todos

RUN apk update \
    && apk add --virtual build-deps build-base gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && rm -rf /var/cache/apk/*

RUN pip install -e .

USER 1001:0

EXPOSE 5000

ENTRYPOINT [ "python" ]
CMD [ "src/todos.py" ]
