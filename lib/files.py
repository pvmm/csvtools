# encoding: utf-8

import csv, zipfile


def open_csv_file(filename, /, delim=';', encoding='utf-8'):
    file = open(filename, encoding=encoding)
    d = csv.DictReader(file, delimiter=delim)
    d._file = file
    d.close = lambda: d._file.close() # coloca arquivo no próprio objeto (uma coisa a menos pra administrar)
    return d

