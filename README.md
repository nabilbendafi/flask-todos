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

## Test
```bash
python3 -m venv env
source env/bin/activate

pip install -e ".[test]"

python -m pytest
coverage run -m pytest
```
