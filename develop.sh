#!/bin/sh

# first, npm install -g nodemon

# re-runs "love src" whenever a src/*.lua file changes
nodemon --watch src -e lua --exec love src
