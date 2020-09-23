#!/bin/env python
# Regenera unicidade em campo token
import sys
from collections import OrderedDict
from lib.files import *

input_file = sys.argv[1]
col = sys.argv[2]

reader = open_csv_file(input_file)
data = {}

for row in reader:
    field = row[col]
    #print('row:', row)
    if field in data.keys():
        # raise SyntaxError() # force uniqueness
        data[field] += 1
    elif field == '':
        raise SyntaxError() # force non-emptiness
    else:
        data[field] = 1

reader.close()
data = OrderedDict(sorted(data.items(), key=lambda t: t[0]))
print(repr(data)) 
