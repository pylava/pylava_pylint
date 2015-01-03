
def test_base():
    from pylama_pylint import Linter
    assert Linter


def test_pylint():
    from pylama.core import run
    from pylama.config import parse_options

    options = parse_options(linters=['pylint'], config=False)
    options.ignore = set(['R0912', 'C0111', 'I0011', 'F0401'])
    errors = run('pylama_pylint/pylint/utils.py', options=options)
    assert len(errors) == 10
    assert errors[0].number == 'W0212'

    options.linters_params['pylint'] = dict(disable="W")
    errors = run('pylama_pylint/pylint/utils.py', options=options)
    assert len(errors) == 2
    assert errors[0].number == 'R0914'

    options.linters_params['pylint']['max-line_length'] = 200
    errors = run('pylama_pylint/pylint/utils.py', options=options)
    assert len(errors) == 2


# pylama:ignore=D
