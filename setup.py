#!/usr/bin/env python

""" Support pylint code checker.

pylama_pylint
-------------

pylama_pylint -- Pylint integration to pylama library.

"""
import re
from os import path as op

from setuptools import setup, find_packages


def _read(fname):
    try:
        return open(op.join(op.dirname(__file__), fname)).read()
    except IOError:
        return ''

_meta = _read('pylama_pylint/__init__.py')
_license = re.search(r'^__license__\s*=\s*"(.*)"', _meta, re.M).group(1)
_project = re.search(r'^__project__\s*=\s*"(.*)"', _meta, re.M).group(1)
_version = re.search(r'^__version__\s*=\s*"(.*)"', _meta, re.M).group(1)

from sys import version_info
if version_info >= (3, 0):
    raise NotImplementedError("Pylint doesnt support python3.")

setup(
    name=_project,
    version=_version,
    license=_license,
    description=_read('DESCRIPTION'),
    long_description=_read('README.rst'),
    platforms=('Any'),

    author='horneds',
    author_email='horneds@gmail.com',
    url='http://github.com/horneds/pylama_pylint',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
    ],
    entry_points={
        'pylama.linter': [
            'pylint = pylama_pylint.main:Linter',
        ],
    },
    packages=find_packages(),
    package_data={'pylama_pylint': ['pylint.rc',
                                    'astroid/brain/py2stdlib.py']},
    install_requires=[
        l for l in _read('requirements.txt').split('\n')
        if l and not l.startswith('#')],
    test_suite='tests',
)
