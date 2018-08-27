MODULE=pylava_pylint
SPHINXBUILD=sphinx-build
ALLSPHINXOPTS= -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) .
BUILDDIR=_build

.PHONY: help
# target: help - Display callable targets
help:
	@egrep "^# target:" [Mm]akefile

.PHONY: clean
# target: clean - Display callable targets
clean:
	@rm -rf build dist docs/_build
	@rm -rf .tox pylava.egg-info .pytest_cache
	@find $(CURDIR) -name "*.orig" -delete
	@find $(CURDIR) -name "*.pyc" -delete

# ==============
#  Bump version
# ==============

.PHONY: release
# target: release - Bump version
release:
	@pip install bumpversion
	@bumpversion $(VERSION)
	@git checkout master
	@git push
	@git push --tags

.PHONY: major
major:
	make release VERSION=major

.PHONY: minor
minor:
	make release VERSION=minor

.PHONY: patch
patch:
	make release VERSION=patch

# ===============
#  Build package
# ===============

.PHONY: upload
# target: upload - Upload module on PyPI
upload: clean
	@pip install twine wheel
	@python setup.py sdist bdist_wheel
	@twine upload dist/* || true

.PHONY: test-upload
# target: test-upload - Upload module on Test PyPI
test-upload: clean
	@pip install twine wheel
	@python setup.py sdist bdist_wheel
	@twine upload --repository-url https://test.pypi.org/legacy/ dist/* || true

# =============
#  Development
# =============

.PHONY: t
# target: t - Runs tests
t: clean
	python setup.py test

.PHONY: audit
# target: audit - Audit code
audit:
	@pylava $(MODULE) -i E501

.PHONY: doc
doc: docs
	python setup.py build_sphinx --source-dir=docs/ --build-dir=docs/_build --all-files
	python setup.py upload_sphinx --upload-dir=docs/_build/html

.PHONY: pep8
pep8:
	find $(MODULE) -name "*.py" | xargs -n 1 autopep8 -i

$(CURDIR)/libs/astroid:
	@mkdir -p libs
	@hg clone https://bitbucket.org/logilab/astroid libs/astroid

$(CURDIR)/libs/logilab-common:
	@mkdir -p libs
	@hg clone https://bitbucket.org/logilab/logilab-common libs/logilab-common

$(CURDIR)/libs/pylint:
	@mkdir -p libs
	@hg clone https://bitbucket.org/logilab/pylint libs/pylint

.PHONY: libs
libs: $(CURDIR)/libs/astroid $(CURDIR)/libs/logilab-common $(CURDIR)/libs/pylint
	@rm -rf $(CURDIR)/pylava_pylint/astroid $(CURDIR)/pylava_pylint/pylint $(CURDIR)/pylava_pylint/logilab
	# Pylint
	@mkdir -p $(CURDIR)/pylava_pylint/pylint
	@cp -rf $(CURDIR)/libs/pylint/pylint/__init__.py        $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/__pkginfo__.py     $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/checkers           $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/config.py          $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/interfaces.py      $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/lint.py            $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/reporters          $(CURDIR)/pylava_pylint/pylint/.
	@cp -rf $(CURDIR)/libs/pylint/pylint/utils.py           $(CURDIR)/pylava_pylint/pylint/.
	# Astroid
	@mkdir -p $(CURDIR)/pylava_pylint/astroid
	@cp -rf $(CURDIR)/libs/astroid/astroid/__init__.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/__pkginfo__.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/exceptions.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/nodes.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/inference.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/raw_building.py  $(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/bases.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/node_classes.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/scoped_nodes.py  $(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/manager.py  	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/mixins.py  	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/modutils.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/helpers.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/protocols.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/brain 		$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/builder.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/rebuilder.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/astpeephole.py 	$(CURDIR)/pylava_pylint/astroid/.
	@cp -rf $(CURDIR)/libs/astroid/astroid/objects.py 	$(CURDIR)/pylava_pylint/astroid/.
	# Common
	@mkdir -p $(CURDIR)/pylava_pylint/logilab/common
	@touch $(CURDIR)/pylava_pylint/logilab/__init__.py
	@cp -f $(CURDIR)/libs/logilab-common/__init__.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/__pkginfo__.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/changelog.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/compat.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/configuration.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/decorators.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/deprecation.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/graph.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/interface.py $(CURDIR)/pylava_pylint/logilab/common/
	@cp -f $(CURDIR)/libs/logilab-common/modutils.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/optik_ext.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/textutils.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/tree.py $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -rf $(CURDIR)/libs/logilab-common/ureports $(CURDIR)/pylava_pylint/logilab/common/.
	@cp -f $(CURDIR)/libs/logilab-common/visitor.py $(CURDIR)/pylava_pylint/logilab/common/.
