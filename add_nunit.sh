#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./add_nunit.sh SUBMISSION_DIRECTORY"
    exit
fi

YEL="\e[33m"
LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- ADDING NUNIT ---${RESET}"

DST_FILE="Program.cs"

SUBMISSION_DIR=$1                                       # Directory of all the submissions
DST_LIST=$(find ${SUBMISSION_DIR} -name "${DST_FILE}")  # Files to be replaced

for DST in ${DST_LIST}
do
    CUR=${DST#"${SUBMISSION_DIR}"}
    echo "${LBLUE}ADDING NUNIT IN${RESET}: ${CUR}"
done
