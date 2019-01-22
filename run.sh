#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./run.sh SUBMISSION_DIRECTORY"
    exit
fi

BYEL="\e[43m"
LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- RUN  ---${RESET}"

SRC_FILES="Program.cs"
EXEC_NAME="out.exe"

SUBMISSION_DIR=$1                            # Directory of all the submissions
BASE=$(pwd)
SOLUTION_NAME=""
DIR_LIST=$(find ${SUBMISSION_DIR} -name "Program.cs" | sort | xargs dirname)

for DIR in ${DIR_LIST}
do
    cd ${DIR}
    INPUT="placeholder"
    echo "${LBLUE}RUNNING FOR PROGRAM IN${RESET}: ${DIR}"

    if [ -n ${INPUT} ] ; then
        ./${EXEC_NAME}
        echo "${BYEL} TEST FINISHED PRESS ENTER TO LAUNCH NEXT TEST ${RESET}"
        read INPUT
    do

    cd ${BASE}
done
