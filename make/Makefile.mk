.DELETE_ON_ERROR:
.DEFAULT_GOAL:=help
PRJ_BUILD?=.project/build
PRJ_DEPENDENCIES?=.project/dependencies
PROJECT_BUILD_MAKE?=.project/build/make

PRJ_TEMP?=.tmp
PRJ_SETUP:=${PRJ_BUILD}/setup
CMD_CONFIG:=${PRJ_BUILD}/make/utils/config.py
TMP_INSTALL_DEV:=${PRJ_TEMP}/${COMPONENT}/install/dev
TMP_INSTALL_TST:=${PRJ_TEMP}/${COMPONENT}/install/tst
TST_BIN:=tests/bin


CMD_HELP:=${PROJECT_BUILD_MAKE}/utils/help.sh

include ${PROJECT_BUILD_MAKE}/targets/*.mk
