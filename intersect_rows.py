#!/bin/env python
# Regenera unicidade em campo token
import sys

from lib.files import *

inp_file = sys.argv[1]
del_file = sys.argv[2]
out_file = sys.argv[3]

reader = open_csv_file(inp_file, delim=',')

tokens = []
with open(del_file, 'r') as tmp:
    for token in tmp:
        tokens.append(token.rstrip())
    out = open(out_file, 'w', newline='')
    writer = csv.DictWriter(out, fieldnames=reader.fieldnames, delimiter=';')
    writer.writeheader()
    count = 0

    for row in reader:
        token = row['token']
        try:
            pos = tokens.index(token)
        except ValueError:
            pos = -1
        if pos != -1:
            count += 1
            writer.writerow(row)
            #print("row:", tokens[pos])
            del tokens[pos]
        else:
            #writer.writerow(row)
            pass

    out.close()
    print("removed rows:", count)
    print("remaining tokens:", len(tokens))
    print("total:", len(tokens) + count)
    print("not found:", tokens)
