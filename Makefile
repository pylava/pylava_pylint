VENV=$(shell echo "$${VDIR:-'.env'}")
MODULE=pylama_pylint
SPHINXBUILD=sphinx-build
ALLSPHINXOPTS= -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
BUILDDIR=_build

all: $(VENV)

$(VENV): requirements.txt
	@[ -d $(VENV) ] || virtualenv --no-site-packages $(VENV)
	@$(VENV)/bin/pip install -r requirements.txt

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile

.PHONY: clean
# target: clean - Display callable targets
clean:
	@rm -rf build dist docs/_build
	@find $(CURDIR) -name "*.orig" -delete
	@find $(CURDIR) -name "*.pyc" -delete

# ==============
#  Bump version
# ==============

.PHONY: release
VERSION?=minor
# target: release - Bump version
release:
	@pip install bumpversion
	@bumpversion $(VERSION)
	@git checkout master
	@git merge develop
	@git checkout develop
	@git push --all
	@git push --tags

.PHONY: minor
minor: release

.PHONY: patch
patch:
	make release VERSION=patch

.PHONY: major
major:
	make release VERSION=major

# ===============
#  Build package
# ===============

.PHONY: register
# target: register - Register module on PyPi
register:
	@python setup.py register

.PHONY: upload
# target: upload - Upload module on PyPi
upload:
	@pip install wheel
	@python setup.py sdist upload || echo 'Already uploaded'
	@python setup.py bdist_wheel upload || echo 'Already uploaded'

# =============
#  Development
# =============

.PHONY: t
# target: t - Runs tests
t: clean $(VENV)
	@$(VENV)/bin/python setup.py test

.PHONY: audit
# target: audit - Audit code
audit:
	@pylama $(MODULE) -i E501

.PHONY: doc
doc: docs
	python setup.py build_sphinx --source-dir=docs/ --build-dir=docs/_build --all-files
	python setup.py upload_sphinx --upload-dir=docs/_build/html

.PHONY: pep8
pep8:
	find $(MODULE) -name "*.py" | xargs -n 1 autopep8 -i

$(CURDIR)/libs/astroid:
	@mkdir -p libs
	@hg clone ssh://hg@bitbucket.org/logilab/astroid libs/astroid

$(CURDIR)/libs/logilab-common:
	@mkdir -p libs
	@hg clone ssh://hg@bitbucket.org/logilab/logilab-common libs/logilab-common

$(CURDIR)/libs/pylint:
	@mkdir -p libs
	@hg clone ssh://hg@bitbucket.org/logilab/pylint libs/pylint

$(CURDIR)/libs/six:
	@mkdir -p libs
	@hg clone https://bitbucket.org/gutworth/six libs/six

.PHONY: libs
libs: $(CURDIR)/libs/astroid $(CURDIR)/libs/logilab-common $(CURDIR)/libs/pylint $(CURDIR)/libs/six
	@rm -rf $(CURDIR)/pylama_pylint/astroid $(CURDIR)/pylama_pylint/pylint $(CURDIR)/pylama_pylint/logilab $(CURDIR)/pylama_pylint/six
	@mkdir -p $(CURDIR)/pylama_pylint/astroid
	@cp -f $(CURDIR)/libs/astroid/astroid/__init__.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/__pkginfo__.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/as_string.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/bases.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/builder.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/exceptions.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/inference.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/inspector.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/manager.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/mixins.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/modutils.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/node_classes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/nodes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/protocols.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/raw_building.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/rebuilder.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/scoped_nodes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/libs/astroid/astroid/utils.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/brain $(CURDIR)/pylama_pylint/astroid/.
	@mkdir -p $(CURDIR)/pylama_pylint/logilab/common
	@touch $(CURDIR)/pylama_pylint/logilab/__init__.py
	@cp -f $(CURDIR)/libs/logilab-common/__init__.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/__pkginfo__.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/changelog.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/compat.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/configuration.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/decorators.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/deprecation.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/graph.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/interface.py $(CURDIR)/pylama_pylint/logilab/common/
	@cp -f $(CURDIR)/libs/logilab-common/modutils.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/optik_ext.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/textutils.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/tree.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -rf $(CURDIR)/libs/logilab-common/ureports $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/visitor.py $(CURDIR)/pylama_pylint/logilab/common/.
	@mkdir -p $(CURDIR)/pylama_pylint/pylint
	@cp -f $(CURDIR)/libs/pylint/__init__.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/pylint/__pkginfo__.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/checkers $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/pylint/config.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/pylint/interfaces.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/pylint/lint.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/reporters $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/pylint/utils.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/libs/six/six.py $(CURDIR)/pylama_pylint/.
