#!/bin/env python
# Regenera unicidade em campo token
import sys

from lib.files import *

input_file = sys.argv[1]
output_file = sys.argv[2]

reader = open_csv_file(input_file)
tokens = {}

with open(output_file, 'w', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=reader.fieldnames, delimiter='\t')
    writer.writeheader()

    for row in reader:
        id = row['token']
        if id in tokens:
            while ('%s-%s' % (id, tokens[id])) in tokens:
                tokens[id] += 1
            row['token'] = '%s-%s' % (id, tokens[id])
        else:
            tokens[id] = 1
        writer.writerow(row)

