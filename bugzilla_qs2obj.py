#!/usr/bin/python

import sys
from urllib.parse import urlparse, parse_qs
import json

urlstring = sys.argv[1]

url = urlparse(urlstring)
qp = parse_qs(url.query)
qp["include_fields"] = ""

try:
    del qp["columnlist"]
    del qp["known_name"]
except KeyError:
    pass

query_dict = {
    "description": "",
    "fetch_cols": [
        "id",
        "summary",
        "status",
        "product",
        "component",
        "target_milestone",
        "priority",
        "bug_severity",
        "cf_last_resolved",
        "cf_status_thunderbird_%CHANNEL%",
    ],
    "queryparams": {},
}

print(qp)
for key, value in qp.items():
    if type(value) == list:
        if len(value) == 1:
            qp[key] = value[0]

query_dict["queryparams"] = qp

print(json.dumps(query_dict, indent=2))
