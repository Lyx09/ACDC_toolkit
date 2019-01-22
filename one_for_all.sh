#!/bin/bash

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./one_for_all.sh SUBMISSION_DIRECTORY"
    exit
fi

LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- ONE FOR ALL ---${RESET}"

SUBMISSION_DIR=$1
CS_LIST=$(find ${SUBMISSION_DIR} -name "*.cs" ! -path "*/Properties/*" ! -path "*/bin/*" ! -path "*/obj/*") # Files concerned

for FILE in ${CS_LIST}
do
    sed -i -r ':a; s%(.*)/\*.*\*/%\1%; ta; /\/\*/ !b; N; ba' ${FILE}    # remove comments using sed
    sed -i -e 's|//.*||g' ${FILE}
    CUR=${FILE#"${SUBMISSION_DIR}"}
    echo "${LBLUE}COMMENTS REMOVED IN${RESET}: ${CUR}"

done


