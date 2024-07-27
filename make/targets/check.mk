#help(format): Autoformats code and sorts imports
format: ${TMP_INSTALL_DEV} setup.d
	black --safe --quiet src/ tests/
	isort src/ tests/

#help(fix): Autoformats code and sorts imports
fix: format

#help-lint(lint-black): Check linting with 'black'
lint-black: ${TMP_INSTALL_DEV} setup.d
	black --check src/ tests/

#help-lint(lint-flake8): Check linting with 'flake8'
lint-flake8: ${TMP_INSTALL_DEV} setup.d
	flake8 src/ tests/
	@flake8 --config /dev/null --select F tests/

#help-lint(mypy): Check typing
mypy: ${TMP_INSTALL_DEV} setup.d
	mypy src/ tests/

#help-lint(lint): Check linting with 'black' and 'flake8'
lint: lint-black lint-flake8

#help(check): Check linting and typing, see 'make help-lint'
check: lint mypy

help-lint:
	@${CMD_HELP} help-lint

.PHONY: format fix lint-black lint-flake8 mypy lint check help-lint
