from sys import platform

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
        if platform.startswith('win'):
            # trailing whitespace is handled differently on win platforms
            args.update({'ignore': ['C0303']})
        errors = run(**args)
        self.assertEqual(len(errors), 16)
