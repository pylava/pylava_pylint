#!/usr/bin/env python

""" Support pylint code checker.

pylama_pylint
-------------

pylama_pylint -- Pylint integration to pylama library.

"""

from os import path as op

from setuptools import setup, find_packages

from pylama_pylint import __version__, __project__, __license__
from sys import version_info


def read(fname):
    try:
        return open(op.join(op.dirname(__file__), fname)).read()
    except IOError:
        return ''

if version_info >= (3, 0):
    raise NotImplementedError("Pylint doesnt support python3.")

setup(
    name=__project__,
    version=__version__,
    license=__license__,
    description=read('DESCRIPTION'),
    long_description=read('README.rst'),
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
    install_requires = [
        l for l in read('requirements.txt').split('\n')
        if l and not l.startswith('#')],
    test_suite = 'tests',
)

# lint_ignore=F0401
