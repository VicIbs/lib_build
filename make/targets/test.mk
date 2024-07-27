#help-test(unit-tests): Run unit-tests
unit-tests: ${TMP_INSTALL_TST} ${TST_BIN}/unit-tests.sh setup.d
	${TST_BIN}/unit-tests.sh

#help-test(integration-tests): Run integrationt-tests
integration-tests: ${TMP_INSTALL_TST} ${TST_BIN}/integration-tests.sh setup.d
	${TST_BIN}/integration-tests.sh

#help(test): Alias for 'make unit-tests', see 'make help-test'
test: unit-tests

help-test:
	@${CMD_HELP} help-test

.PHONY: unit-tests integration-tests test help-test
