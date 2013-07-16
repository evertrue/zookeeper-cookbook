#!/usr/bin/env python

import itertools
import json
import logging
import socket
import sys
import urllib2
import urlparse
from unittest import TestCase


log = logging.getLogger(__name__)
try:
    log.addHandler(logging.NullHandler())
except AttributeError:
    # py 2.6 compatibility
    pass


class CheckException(Exception):
    CODE = 3


class WarningException(CheckException):
    CODE = 1


class CriticalException(CheckException):
    CODE = 2


class UnknownException(CheckException):
    CODE = 3


def fetch_status(host):
    status_url = urlparse.urljoin(host, '/exhibitor/v1/cluster/status')

    f = urllib2.urlopen(status_url, timeout=10)

    if f.getcode() != 200:
        raise UnknownException("Non 200 response from exhibitor")

    return json.loads(f.read())


def check(status):
    """Check the status of Exhibitor and raise CheckException if error."""

    node_serving = lambda node: node["description"] == "serving"

    # how many nodes are down
    down_nodes = len(list(itertools.ifilterfalse(node_serving, status)))
    max_down = (len(status) - 1) / 2
    if down_nodes:
        if max_down > down_nodes:
            raise WarningException(
                "There are %s down nodes. We can handle a maximum of %s." % (
                down_nodes, max_down)
            )
        else:
            raise CriticalException("There are %s down nodes." % down_nodes)

    # how many nodes are up
    up_nodes = len(list(itertools.ifilter(node_serving, status)))
    if not up_nodes:
        raise CriticalException("There are no up nodes.")

    # at least one node is leader
    has_leader = any(node["isLeader"] for node in status)
    if not has_leader:
        raise CriticalException("There appears to be no leader.")


class TestCheck(TestCase):

    @staticmethod
    def generate(n_serving, n_down, leader=None):
        nodes = (
            [{"description": "serving"} for i in xrange(n_serving)] +
            [{"description": "sick"} for i in xrange(n_down)]
        )
        for node in nodes:
            node["isLeader"] = False

        for node in nodes:
            if node["description"] == leader:
                node["isLeader"] = True
                break

        return nodes

    def test_okay(self):
        check(self.generate(2, 0, "serving"))

    def test_no_nodes(self):
        self.assertRaises(CriticalException, check, self.generate(0, 0))

    def test_no_leader(self):
        self.assertRaises(CriticalException, check, self.generate(1, 0))

    def test_down_nodes(self):
        self.assertRaises(CriticalException, check, self.generate(2, 1))

    def test_warn_on_down_nodes(self):
        """warn if there's a failure but can still handle at least 1 more.

        (n_servers - 1) / 2 > n_down

        """
        self.assertRaises(WarningException, check, self.generate(4, 1))


if __name__ == '__main__':
    socket.setdefaulttimeout(1)
    log.addHandler(logging.StreamHandler(sys.stderr))

    try:
        if len(sys.argv) != 2:
            raise UnknownException(
                "Pass the exhibitor host as the first positional parameter."
            )

        status = fetch_status(sys.argv[1])
        check(status)

    except CheckException, e:
        log.error(e.message)
        sys.exit(e.CODE)
    except Exception, e:
        log.exception(e)
        sys.exit(UnknownException.CODE)
