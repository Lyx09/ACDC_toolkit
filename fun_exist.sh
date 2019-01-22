#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./fun_exist.sh SUBMISSION_DIRECTORY"
    exit
fi

RED="\e[31m"
LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- FUNCTION EXIST ---${RESET}"

FUN_LIST="fun_list.txt"

SUBMISSION_DIR=$1                            # Directory of all the submissions
BASE=$(pwd)
FUN_LIST_LOCATION=${BASE}/${FUN_LIST}
DIR_LIST=$(find ${SUBMISSION_DIR} -name "Program.cs" | sort | xargs dirname)

for DIR in ${DIR_LIST}
do
    cd ${DIR}
    echo "${LBLUE}CHECKING FUNCTION PRESENCE${RESET}: ${DIR}"

    while IFS= read -r LINE
    do
        EXIST=$(grep -r --include=\*.cs  ${LINE} | grep -v ";" | wc -l)
        if [ $EXIST -lt 1 ]; then
            echo "${RED}Function ${LINE} was not found${RESET}"
        fi
    done < "${FUN_LIST_LOCATION}"

    cd ${BASE}
done
