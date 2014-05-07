from unittest import TestCase


class Pylama_pylintTests(TestCase):

    def test_base(self):
        from pylama_pylint import __version__
        self.assertTrue(__version__)

    def test_pylint(self):
        from pylama.core import run
        from pylama.config import parse_options

        options = parse_options(linters=['pylint'], config=False)
        errors = run('pylama_pylint/pylint/utils.py', options=options)
        self.assertEqual(len(errors), 32)
