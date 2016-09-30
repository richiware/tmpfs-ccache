#!/bin/bash

# From config file. See: /etc/systemd/system/tmpfs-ccache.service
TMPFS=$2
PERSISTENT=$3
SIZE=$4

# Permission for directories
PERM=777

if [ "$1" == "start" ];then
    echo Starting... T=$TMPFS P=$PERSISTENT S=$SIZE

    if [ ! -d $PERSISTENT ];then
        echo $PERSISTENT do not exist. Creating...
        mkdir -p $PERSISTENT
        chmod $PERM $PERSISTENT
    fi

    mkdir -p $TMPFS
    if [ $? != 0 ];then
        echo Error creating $TMPFS
        exit 1
    fi

    chmod $PERM $TMPFS

    rsync $RSYNC_OPTS $PERSISTENT/ $TMPFS/ &> /dev/null
    if [ $? != 0 ];then
        echo Error on rsync $RSYNC_OPTS $PERSISTENT/ $TMPFS/
        exit 1
    fi

    echo done.
    exit 0
fi

if [ "$1" == "stop" ];then
    echo Stopping...

    # --delete is added only here
    rsync $RSYNC_OPTS --delete $TMPFS/ $PERSISTENT/ &> /dev/null
    if [ $? != 0 ];then
        echo Error on rsync $RSYNC_OPTS --delete $TMPFS/ $PERSISTENT/
        exit 1
    fi

    echo done.
    exit 0
fi

echo You should not call me directly
exit 1
