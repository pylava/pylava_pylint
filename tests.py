
def test_base():
    from pylama_pylint import Linter
    assert Linter


def test_pylint():
    from pylama.core import run
    from pylama.config import parse_options

    options = parse_options(linters=['pylint'], config=False)
    errors = run('pylama_pylint/pylint/utils.py', options=options)
    assert len(errors) == 25
    assert errors[0].number == 'W00622'


# pylama:ignore=D
