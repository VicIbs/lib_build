#!/usr/bin/env python3

import configparser
import pathlib
import sys
import re


class SortedDict(dict):
    def __iter__(Self):
        yield from sorted(super().__iter__())

    def items(self):
        yield from sorted(super().items(), key=lambda tpl: tpl[0])


class ParamSet(set):
    def __init__(self, string, single_line=False, complex_sep=':'):
        split = re.split('\n' if complex_sep in string else '\n|,', string)
        super().__init__({s.split('#')[0].strip() for s in split if s})
        self.single_line = single_line

    def __str__(self):
        if self.single_line or len(self) == 1:
            return ','.join(sorted(self))
        return '\n' + '\n'.join(sorted(self))


class ParamDict(SortedDict):
    def __init__(self, string):
        for key, param in [s.strip().split(':') for s in string.split('\n') if s]:
            if key not in self:
                self[key] = ParamSet(param, single_line=True)
            else:
                self[key].update(ParamSet(param))

    def __str__(self):
        return '\n'.join([''] + [f'{k}:{v}' for k, v in self.items()])


class SortedParams(str):
    def __new__(cls, s):
        if s.startswith('\n'):
            try:
                s = ParamDict(s)
            except ValueError:
                s = ParamSet(s, single_line=False)
        return str.__new__(cls, s)


class Config(configparser.ConfigParser):
    def __init__(self, path):
        super().__init__(dict_type=SortedDict)
        self.read(path)

    def merge(self, cfg):
        for section_key, section_obj in cfg.items():
            if section_key not in self:
                self[section_key] = section_obj
                continue
            for option_key, params in [(key, ParamSet(val)) for key, val in section_obj.items()]:
                if option_key in self[section_key]:
                    params.update(ParamSet(self[section_key][option_key]))
                self[section_key][option_key] = str(params)

    def print(self):
        for section in self.values():
            for key, param in section.items():
                section[key] = SortedParams(param)
        self.write(sys.stdout)


if __name__ == '__main__':
    cfg_path = pathlib.Path(__file__).parent
    cfg = Config(cfg_path.glob('../../setup/*.cfg'))
    cfg.merge(Config([pathlib.Path(arg) for arg in sys.argv[1:]]))
    cfg.print()
