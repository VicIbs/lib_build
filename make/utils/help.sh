#!/usr/bin/env sh

[ -n "$1" ] || exit 1
[ -n "${MAKEFILE_LIST}" ] || exit 2

sed -n "s|#$1(\(.*\)): \(.*\)|\"make \1\" \"\2\"|p" ${MAKEFILE_LIST} | sort |
  while read -r line; do
    eval "printf '\e[92m%s\e[0m\n - %s.\n' ${line}"
  done
