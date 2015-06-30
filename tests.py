
def test_base():
    from pylama_pylint import Linter
    assert Linter


def test_pylint():
    from pylama.core import run
    from pylama.config import parse_options

    options = parse_options(linters=['pylint'], config=False)
    options.ignore = set(['R0912', 'C0111', 'I0011', 'F0401'])
    errors = run('dummy.py', options=options)
    assert len(errors) == 3
    assert errors[0].number == 'W0611'

    options.linters_params['pylint'] = dict(disable="W")
    errors = run('dummy.py', options=options)
    assert len(errors) == 1
    assert errors[0].number == 'E0602'

    options.linters_params['pylint']['max-line_length'] = 200
    errors = run('dummy.py', options=options)
    assert len(errors) == 1


# pylama:ignore=D
