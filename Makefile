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
