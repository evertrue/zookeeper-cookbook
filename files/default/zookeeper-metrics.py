#!/usr/bin/env python

import argparse
import json
import socket
import time
import urllib2
import urlparse

def get_stat(host, hostname):
    path = '/exhibitor/v1/cluster/4ltr/mntr/' + hostname

    stat_url = urlparse.urljoin(host, path)
    #url = urlparse.urlsplit(stat_url)
    #socket.gethostbyaddr(url[1].split(':')[0])

    f = urllib2.urlopen(stat_url, timeout=30)

    if f.getcode() != 200:
        raise Exception("Non 200 response from exhibitor")

    return json.loads(f.read())['response']


def stat_fanout(host):
    from check_exhibitor import fetch_status

    hosts = [h['hostname'] for h in fetch_status(host)]
    for hostname in hosts:
        yield hostname, parse_response(get_stat(host, hostname))

def stat_localhost(host):
    yield socket.gethostname(), parse_response(get_stat(host, 'localhost'))

def parse_response(response):
    return response.decode('string-escape').strip("\n\"").split("\n")


def main(prefix, hostname, stat_generator):
    socket.setdefaulttimeout(1)
    for host, resp in stat_generator(hostname):
        # kv takes the form {key}\t{value}
        for kv in resp:
            print "%s.exhibitor.%s.%s\t%d" % (
                prefix, host.replace('.', '-'), kv, time.time())


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('prefix', help='graphite key prefix.')
    parser.add_argument('host', help='host to collect metrics from')
    parser.add_argument('--fan-out', action='store_true', default=False,
                        help='If specified, fanout to all zookeepers and return combined metrics.')

    args = parser.parse_args()
    path_prefix = args.prefix.rstrip('.')

    if args.fan_out:
        main(path_prefix, args.host, stat_fanout)
    else:
        main(path_prefix, args.host, stat_localhost)
