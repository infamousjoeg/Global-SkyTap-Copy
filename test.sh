#!/bin/bash
set -eo pipefail

summon docker run --name gsc_test -d -e 'SKYTAP_USER=$SKYTAP_USER' -e 'SKYTAP_PASS=$SKYTAP_PASS' nfmsjoeg/gsc:test
