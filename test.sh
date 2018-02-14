#!/bin/bash
set -eo pipefail

summon docker run --name gsc_test -i --env-file @SUMMONENVFILE nfmsjoeg/gsc:test > test.log
