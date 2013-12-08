VIRTUALENV=$(shell echo "$${VDIR:-'.env'}")
MODULE=pylama_pylint
SPHINXBUILD=sphinx-build
ALLSPHINXOPTS= -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
BUILDDIR=_build

all: $(VIRTUALENV)

$(VIRTUALENV): requirements.txt
	@virtualenv --no-site-packages $(VIRTUALENV)
	@$(VIRTUALENV)/bin/pip install -M -r requirements.txt
	touch $(VIRTUALENV)

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile

.PHONY: clean
# target: clean - Display callable targets
clean:
	@rm -rf build dist docs/_build
	@rm -f *.py[co]
	@rm -f *.orig
	@rm -f */*.py[co]
	@rm -f */*.orig

.PHONY: register
# target: register - Register module on PyPi
register:
	@python setup.py register

.PHONY: upload
# target: upload - Upload module on PyPi
upload:
	@python setup.py sdist upload || echo 'Upload already'

.PHONY: t
# target: t - Runs tests
t: clean
	@python setup.py test

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

$(CURDIR)/astroid:
	hg clone ssh://hg@bitbucket.org/logilab/astroid

$(CURDIR)/logilab-common:
	hg clone ssh://hg@bitbucket.org/logilab/logilab-common

$(CURDIR)/pylint:
	hg clone ssh://hg@bitbucket.org/logilab/pylint

.PHONY: pylint
pylint: $(CURDIR)/astroid $(CURDIR)/logilab-common $(CURDIR)/pylint
	@rm -rf $(CURDIR)/pylama_pylint/astroid $(CURDIR)/pylama_pylint/pylint $(CURDIR)/pylama_pylint/logilab
	@mkdir -p $(CURDIR)/pylama_pylint/astroid
	@cp -f $(CURDIR)/astroid/__init__.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/__pkginfo__.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/as_string.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/bases.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/builder.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/exceptions.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/inference.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/manager.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/mixins.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/node_classes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/nodes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/protocols.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/raw_building.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/rebuilder.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/scoped_nodes.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -f $(CURDIR)/astroid/utils.py $(CURDIR)/pylama_pylint/astroid/.
	@cp -rf $(CURDIR)/astroid/brain $(CURDIR)/pylama_pylint/astroid/.
	@mkdir -p $(CURDIR)/pylama_pylint/logilab/common
	@touch $(CURDIR)/pylama_pylint/logilab/__init__.py
	@cp -f $(CURDIR)/logilab-common/__init__.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/__init__.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/__pkginfo__.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/changelog.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/compat.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/configuration.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/decorators.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/deprecation.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/graph.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/interface.py $(CURDIR)/pylama_pylint/logilab/common/
	@cp -f $(CURDIR)/logilab-common/modutils.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/optik_ext.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/textutils.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/tree.py $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -rf $(CURDIR)/logilab-common/ureports $(CURDIR)/pylama_pylint/logilab/common/.
	@cp -f $(CURDIR)/logilab-common/visitor.py $(CURDIR)/pylama_pylint/logilab/common/.
	@mkdir -p $(CURDIR)/pylama_pylint/pylint
	@cp -f $(CURDIR)/pylint/__init__.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/pylint/__pkginfo__.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -rf $(CURDIR)/pylint/checkers $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/pylint/config.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/pylint/interfaces.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/pylint/lint.py $(CURDIR)/pylama_pylint/pylint/.
	@cp -rf $(CURDIR)/pylint/reporters $(CURDIR)/pylama_pylint/pylint/.
	@cp -f $(CURDIR)/pylint/utils.py $(CURDIR)/pylama_pylint/pylint/.
