#!/bin/sh
while read FILE
do
    if [ -f $FILE ]; then
        rm $FILE
    fi
done < grep.log.bak
