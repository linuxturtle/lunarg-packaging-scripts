#!/bin/bash
usage="$0 [-c <commitID/tag/branch>] [-i <branch to ignore> ]"

commitID=""
ignoreBranch=""
while getopts ":c:i:" options; do
    case $options in
	c ) commitID="${OPTARG}..";;
	i ) ignoreBranch="^${OPTARG}";;
	* ) echo $usage
	    exit 1;;
    esac
done

git rev-list ${commitID}HEAD ${ignoreBranch} --count
