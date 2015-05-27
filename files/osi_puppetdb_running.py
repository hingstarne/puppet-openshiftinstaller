#!/usr/bin/env python

from subprocess import Popen, PIPE
import json
from sys import exit

cmdline = "curl -s http://localhost:8080/v3/metrics/mbeans"

NO="no"
YES="yes"

def fact(str):
    print("osi_puppetdb_running={}".format(str))
    exit(0)

if __name__ == "__main__":
    try:
        popen  = Popen(cmdline.split(), stdout=PIPE)
        result = popen.wait()
    except:
        fact(NO)

    if not result == 0:
        fact(NO)
    else:
        try:
            text = popen.stdout.read()
            jobj = json.loads(text)
            if type(jobj) == dict:
                fact(YES)
        except ValueError:
            pass
        fact(NO)

