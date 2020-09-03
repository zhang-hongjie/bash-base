#!/usr/bin/env bash

if [[ "$(node -p "require('is-installed-globally')")" == "true" ]]; then
	echo "npm installed globally"
	source bash-base
fi
