import os
import pathlib
import re

import setuptools


class Version(str):
    REGEX = re.compile("((\d+\.?)+)")

    def strip(self):
        match = self.REGEX.search(self)
        return match[0] if match and '.' in match[0] else "0.0.0"


class MakeEnv(dict):
    def __init__(self, path):
        super().__init__()
        assignments = {
            ":=": self._simple_assignment,
            "?=": self._conditional_assignment,
        }
        with open(path, "r") as env_file:
            for line in env_file:
                for key, method in assignments.items():
                    if key in line:
                        method(*[s.strip() for s in line.split(key)])

    def _simple_assignment(self, key, val):
        self[key] = val.replace("${", "{").format(**self)

    def _conditional_assignment(self, key, val):
        if key in os.environ:
            self[key] = os.environ[key]
        else:
            self._simple_assignment(key, val)

    def get_version(self) -> str:
        with open(self["VERSION"], "r") as version_file:
            for line in version_file:
                if "__version__" in line:
                    return Version(line).strip()
            raise KeyError("Version is missing from version file")


make_env = MakeEnv(pathlib.Path("Makefile"))
setuptools.setup(version=make_env.get_version())
