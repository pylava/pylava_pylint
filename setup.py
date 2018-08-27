#!/usr/bin/env python

""" Support pylint code checker.

pylava_pylint
-------------

pylava_pylint -- Pylint integration to pylava library.

"""
import re
import sys
from os import path as op

from setuptools import setup, find_packages
from setuptools.command.test import test as TestCommand


def _read(fname):
    try:
        return open(op.join(op.dirname(__file__), fname)).read()
    except IOError:
        return ''

_meta = _read('pylava_pylint/__init__.py')
_license = re.search(r'^__license__\s*=\s*"(.*)"', _meta, re.M).group(1)
_project = re.search(r'^__project__\s*=\s*"(.*)"', _meta, re.M).group(1)
_version = re.search(r'^__version__\s*=\s*"(.*)"', _meta, re.M).group(1)


class __PyTest(TestCommand):

    test_args = []
    test_suite = True

    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = ['tests.py']
        self.test_suite = True

    def run_tests(self):
        import pytest
        errno = pytest.main(self.test_args)
        sys.exit(errno)

setup(
    name=_project,
    version=_version,
    license=_license,
    description=_read('DESCRIPTION').strip(),
    long_description=_read('README.rst'),
    platforms=('Any'),

    maintainer='Susam Pal',
    maintainer_email='susam@susam.in',
    url='http://github.com/pyfocus/pylava_pylint',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
    ],
    entry_points={
        'pylava.linter': [
            'pylint = pylava_pylint.main:Linter',
        ],
    },
    packages=find_packages(),
    package_data={'pylava_pylint': ['pylint.rc']},
    install_requires=[
        l for l in _read('requirements.txt').split('\n')
        if l and not l.startswith('#')],
    tests_require=['pytest'],
    cmdclass={'test': __PyTest},
)
