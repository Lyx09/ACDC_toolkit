#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./correct.sh SUBMISSION_DIRECTORY"
    exit
fi

BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- LAUNCHING CORRECTION ---${RESET}"

./public.sh $1

./replace_main.sh $1

./compile.sh $1

./run.sh $1
