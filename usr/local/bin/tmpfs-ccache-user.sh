#!/bin/bash

# Load config variables
. /etc/tmpfs-ccache

export CCACHE_DIR=$USERTMPFS

ccache -F 0 -M $USERSIZE &> /dev/null
