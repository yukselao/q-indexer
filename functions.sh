#!/bin/bash


function plog() {
        echo $(date "+%F %T") $@
}

function wlog() {
        echo $(date "+%F %T") $@ >> /tmp/${sessionname}.log
}
