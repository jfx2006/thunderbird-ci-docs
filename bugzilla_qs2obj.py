#!/usr/bin/python

import sys
from urllib.parse import (
    urlparse,
    parse_qs
)
import json

urlstring = sys.argv[1]

url = urlparse(urlstring)
qp = parse_qs(url.query)
qp['include_fields'] = ''
del qp['columnlist']
try:
    del qp['known_name']
except KeyError:
    pass

print(qp)
for key, value in qp.items():
    if type(value) == list:
        if len(value) == 1:
            qp[key] = value[0]

print(json.dumps(qp, indent=2))
