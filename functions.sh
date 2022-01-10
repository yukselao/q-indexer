#!/bin/bash


function plog() {
        echo $(date "+%F %T") $@
}

function wlog() {
        echo $(date "+%F %T") $@ >> /tmp/${sessionname}.log
}

function getconf() {
	cat config.ini |grep "$1=" |sed -r "s#^"$1'=(.+?)$#\1#'
}
