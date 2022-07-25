#!/usr/bin/env bash

who | awk -F: '{ print $1 }'
