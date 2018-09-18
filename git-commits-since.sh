#!/bin/bash
usage="$0 [-c <commitID/tag/branch>]"

commitID=""
while getopts ":c:" options; do
    case $options in
	c ) commitID="${OPTARG}..";;
	* ) echo $usage
	    exit 1;;
    esac
done

git log --oneline ${commitID}HEAD | wc -l
