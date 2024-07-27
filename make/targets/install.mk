${TMP_INSTALL_DEV}: setup.d
	@pip install ${PIP_ARGS} -e '.[dev]'
	@install -m 644 -D /dev/null ${TMP_INSTALL_DEV}

${TMP_INSTALL_TST}: setup.d
	@pip install ${PIP_ARGS} -e '.[tests]'
	@install -m 644 -D /dev/null ${TMP_INSTALL_TST}

${TMP_SRC_CHANGED}: setup.d $(shell find src/ -type f -iname '*.py')
	@install -m 644 -D /dev/null ${TMP_SRC_CHANGED}

#help(install-dependencies): Install dependencies
install-dependencies: setup.d
	@${PRJ_BUILD}/make/utils/install-dependencies.sh ${PRJ_DEPENDENCIES}/*

#help-install(install-production): Install component for production
# install-production:+.

#help-install(install-development): Install component with development- and test-dependencies
install-development: install-dependencies
	@pip install ${PIP_ARGS} -e '.[all]'
	@install -m 644 -D /dev/null ${TMP_INSTALL_TST}
	@install -m 644 -D /dev/null ${TMP_INSTALL_DEV}
	
#help(install): Alias for 'make install-development, see 'make help-install'
install: install-development

help-install:
	@${CMD_HELP} help-install

.PHONY: install install-development install-production help-install
