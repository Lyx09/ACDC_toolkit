#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./compile.sh SUBMISSION_DIRECTORY"
    exit
fi

LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- COMPILE ---${RESET}"

SRC_FILES="Program.cs"
EXEC_NAME="out.exe"

SUBMISSION_DIR=$1                            # Directory of all the submissions
BASE=$(pwd)
SOLUTION_NAME=""
DIR_LIST=$(find ${SUBMISSION_DIR} -name "Program.cs" | sort | xargs dirname)

for DIR in ${DIR_LIST}
do
    cd ${DIR}
    echo "${LBLUE}COMPILING IN${RESET}: ${DIR}"

    mcs -out:${EXEC_NAME} ${SRC_FILES}
    cd ${BASE}
done
