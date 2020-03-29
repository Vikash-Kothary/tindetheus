#/bin/make
#@ Tindetheus

TINDETHEUS_ROOT := ${PWD}
TINDETHEUS_NAME := "$(shell python3 ${TINDETHEUS_ROOT}/setup.py --name)"
TINDETHEUS_VERSION := "$(shell python3 ${TINDETHEUS_ROOT}/setup.py --version)"
TINDETHEUS_DESCRIPTION := "$(shell python3 ${TINDETHEUS_ROOT}/setup.py --description)"
SHELL := /bin/bash
PATH := "${TINDETHEUS_ROOT}/.venv/bin:${PATH}"

-include .env
export

%: %-tindetheus
	@true

.DEFAULT_GOAL := help-tindetheus
.PHONY: help-tindetheus #: Display this help.
help-tindetheus:
	@cd ${TINDETHEUS_ROOT} && awk 'BEGIN {FS = " ?#?: "; print ""${TINDETHEUS_NAME}" "${TINDETHEUS_VERSION}"\n"${TINDETHEUS_DESCRIPTION}"\n\nUsage: make \033[36m<command>\033[0m\n\nCommands:"} /^.PHONY: ?[a-zA-Z_-]/ { printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3 }' $(MAKEFILE_LIST)

.PHONY: init-tindetheus #: Download dependences.
init-tindetheus: 
	@cd ${TINDETHEUS_ROOT} && \
	pip install --upgrade -r requirements.txt && \
	pip install PyQt5

.PHONY: lint-tindetheus #: Run code quality checks.
lint-tindetheus:
	@cd ${TINDETHEUS_ROOT} && \
	find tindetheus -name '*.py' -maxdepth 1 -print0 | xargs -0 flake8

.PHONY: tests-tindetheus #: Run tests.
tests-tindetheus:
	@cd ${TINDETHEUS_ROOT} && \
	pytest -p no:warnings --doctest-modules tests/tests.py

.PHONY: tests-tindetheus #: Run tests.
notebooks-tindetheus:
	@cd ${TINDETHEUS_ROOT} && \
	jupyter notebook --notebook-dir=./notebooks