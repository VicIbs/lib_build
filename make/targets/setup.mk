GITDIR:=$(or $(shell cat .git 2>/dev/null | sed 's/gitdir: //'), .git)

${VERSION}: ${GITDIR}/HEAD ${GITDIR}/refs/tags
	@printf '__version__ = "%s"\n' "$(shell git describe --tag --always)" > ${VERSION}

setup.py: ${PRJ_SETUP}/setup.py
	@cat ${PRJ_SETUP}/setup.py > setup.py

setup.cfg: setup.d/*.cfg ${PRJ_SETUP}/*.cfg ${CMD_CONFIG}
	@${CMD_CONFIG} setup.d/*.cfg > setup.cfg

pyproject.toml: ${PRJ_SETUP}/*.toml
	@cat ${PRJ_SETUP}/*.toml > pyproject.toml

setup.d: setup.py setup.cfg pyproject.toml ${VERSION}
	@touch setup.d

version: ${VERSION}

.PHONY: version
