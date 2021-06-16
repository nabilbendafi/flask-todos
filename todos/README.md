# Flask TODO app


## Installation

```bash
python3 -m venv env
source env/bin/activate

pip install -e .
```

## Run
```bash
./src/todos
```

## Build Docker image
```bash
docker build -t flask-todos .
docker tag flask-todos gcr.io/<project_id>/flask-todos
docker push gcr.io/<project_id>/flask-todos
```

## Test
```bash
python3 -m venv env
source env/bin/activate

pip install -e ".[test]"

python -m pytest
coverage run -m pytest
```

# TODO
 - Move to production ready server
