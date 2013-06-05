#!/usr/bin/env python

import itertools
import json
import socket
import sys
import time
import urllib
import urlparse

from check_exhibitor import fetch_status

def get_stat(host, hostname):
    path = '/exhibitor/v1/cluster/4ltr/stat/' + hostname

    stat_url = urlparse.urljoin(host, path)
    f = urllib.urlopen(stat_url)

    if f.getcode() != 200:
        raise Exception("Non 200 response from exhibitor")

    return json.loads(f.read())['response']


def do(host):
    hosts = [h['hostname'] for h in fetch_status(host)]
    for hostname in hosts:
        yield hostname, parse_response(get_stat(host, hostname))


def parse_response(response):
    vals = response.split("\\n")
    for kv in vals:
        yield kv.split(': ', 1)

if __name__ == '__main__':
    root_host = sys.argv[1]
    socket.setdefaulttimeout(1)
    for host, resp in do(root_host):
        for kv in itertools.islice(
            itertools.ifilter(lambda x: len(x) == 2, resp), 2, 9):

            print "exhibitor.%s.%s\t%s\t%d" % (host, kv[0], kv[1], time.time())
