""" Pylint support. """
from os import path as op, environ
import sys

from pylama.lint import Linter as BaseLinter

CURDIR = op.abspath(op.dirname(__file__))
sys.path.insert(0, CURDIR)

from astroid import MANAGER
from pylint.lint import Run
from pylint.reporters import BaseReporter

HOME_RCFILE = op.abspath(op.join(environ.get('HOME', ''), '.pylintrc'))
LAMA_RCFILE = op.abspath(op.join(CURDIR, 'pylint.rc'))


class Linter(BaseLinter):

    """ Check code with pylint. """

    @staticmethod
    def run(path, code, **params):
        """ Pylint code checking.

        :return list: List of errors.

        """
        MANAGER.astroid_cache.clear()

        class Reporter(BaseReporter):

            def __init__(self):
                self.errors = []
                super(Reporter, self).__init__()

            def _display(self, layout):
                pass

            def add_message(self, msg_id, location, msg):
                _, _, line, col = location[1:]
                self.errors.append(dict(
                    lnum=line,
                    col=col,
                    text="%s %s" % (msg_id, msg),
                    type=msg_id[0]
                ))

        params = _Params(**params)
        runner = Run(
            [path] + params.to_attrs(), reporter=Reporter(), exit=False)

        return runner.linter.reporter.errors


class _Params(object):

    """ Store pylint params. """

    def __init__(self, rcfile=LAMA_RCFILE, select=None, ignore=None,
                 report=False, enable=None, disable=None, **params):

        if op.exists(HOME_RCFILE):
            rcfile = HOME_RCFILE

        if select:
            enable = select | set(enable.split(",") if enable else [])

        if ignore:
            disable = ignore | set(disable.split(",") if disable else [])

        self.params = dict(
            (name.replace('_', '-'), self.prepare_value(value))
            for name, value in dict(
                rcfile=rcfile, report=report, enable=enable, disable=disable,
                **params).items() if value is not None)

    @staticmethod
    def prepare_value(value):
        """ Prepare value to pylint. """
        if isinstance(value, (list, tuple, set)):
            return ",".join(value)

        if isinstance(value, bool):
            return "y" if value else "n"

        return str(value)

    def to_attrs(self):
        """ Convert to argument list. """
        return ["--%s=%s" % item for item in self.params.items()]

    def __str__(self):
        return " ".join(self.to_attrs())

    def __repr__(self):
        return "<Pylint %s>" % self

# pylama:ignore=W0403
