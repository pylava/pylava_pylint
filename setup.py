#!/usr/bin/env python

""" Support pylint code checker.

pylama_pylint
-------------

pylama_pylint -- Pylint integration to pylama library.

"""

from os import path as op

from setuptools import setup, find_packages

from sys import version_info


def __read(fname):
    try:
        return open(op.join(op.dirname(__file__), fname)).read()
    except IOError:
        return ''

if version_info >= (3, 0):
    raise NotImplementedError("Pylint doesnt support python3.")

setup(
    name='pylama_pylint',
    version='0.1.6',
    license='BSD',
    description=__read('DESCRIPTION'),
    long_description=__read('README.rst'),
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
    package_data={'pylama_pylint': ['pylint.rc']},
    install_requires=[
        l for l in __read('requirements.txt').split('\n')
        if l and not l.startswith('#')],
    test_suite='tests',
)

# lint_ignore=F0401
