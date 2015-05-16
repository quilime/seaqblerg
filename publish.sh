#!/bin/bash

set -x

jekyll build
rsync -var _site/ seaquence@seaquence.org:dev.seaquence.org/blerg/
