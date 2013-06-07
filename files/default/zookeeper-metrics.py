#!/usr/bin/env python

import json
import socket
import sys
import time
import urllib
import urlparse

from check_exhibitor import fetch_status

def get_stat(host, hostname):
    path = '/exhibitor/v1/cluster/4ltr/mntr/' + hostname

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
    return response.decode('string-escape').strip("\n\"").split("\n")

if __name__ == '__main__':
    root_host = sys.argv[1]
    socket.setdefaulttimeout(1)
    for host, resp in do(root_host):
        # kv takes the form {key}\t{value}
        for kv in resp:
            print "exhibitor.%s.%s\t%d" % (host.replace('.', '-'), kv, time.time())
