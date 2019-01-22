#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./public.sh SUBMISSION_DIRECTORY"
    exit
fi

LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- PRIVATE TO PUBLIC ---${RESET}"

SUBMISSION_DIR=$1                                       # Directory of all the submissions
CS_LIST=$(find ${SUBMISSION_DIR} -name "*.cs" ! -path "*Properties*" ! -path "*bin*" ! -path "*obj*") # Files concerned

for FILE in ${CS_LIST}
do
    CUR=${FILE#"${SUBMISSION_DIR}"}
    echo "${LBLUE}REPLACING PRIVATE KEYWORD${RESET}: ${CUR}"

    sed -i -e 's/private\|protected/public/g' ${FILE}
done

