from unittest import TestCase


class Pylama_pylintTests(TestCase):

    def test_base(self):
        from pylama_pylint import __version__
        self.assertTrue(__version__)

    def test_pylint(self):
        from pylama.core import run

        args = {
            'path': 'pylama_pylint/pylint/utils.py',
            'linters': ['pylint']}
        errors = run(**args)
        self.assertEqual(len(errors), 40)

