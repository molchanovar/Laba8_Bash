#!/usr/bin/env bash

lines () {
    cat $1 | wc -l
}

num=$( lines $1 )
echo "$num"
