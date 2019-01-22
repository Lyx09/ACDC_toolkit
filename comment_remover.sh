#!/bin/bash

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./comment_remover.sh SUBMISSION_DIRECTORY"
    exit
fi

BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- REMOVE COMMENTS ---${RESET}"

SUBMISSION_DIR=$1                                       # Directory of all the submissions
CS_LIST=$(find ${SUBMISSION_DIR} -name "*.cs" ! -path "*/Properties/*" ! -path "*/bin/*" ! -path "*/obj/*") # Files concerned

for FILE in ${CS_LIST}
do
    sed -i -r ':a; s%(.*)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba' ${FILE}    # remove comments using sed
    sed -i -e 's|//.*||g' ${FILE}
    CUR=${FILE#"${SUBMISSION_DIR}"}
    echo "${LBLUE}COMMENTS REMOVED IN${RESET}: ${CUR}"

done


