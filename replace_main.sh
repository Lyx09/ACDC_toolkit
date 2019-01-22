#!/bin/sh

if [ $# != 1 ] ; then
    echo "Missing argument."
    echo "Usage: ./replace_main.sh SUBMISSION_DIRECTORY"
    exit
fi

YEL="\e[33m"
LBLUE="\e[94m"
BLUE="\e[34m"
RESET="\e[0m"
echo "${BLUE}--- REPLACING MAIN ---${RESET}"

SRC_FILE="main_swap.cs"
DST_FILE="Program.cs"

SUBMISSION_DIR=$1                                       # Directory of all the submissions
DST_LIST=$(find ${SUBMISSION_DIR} -name "${DST_FILE}")  # Files to be replaced

for DST in ${DST_LIST}
do
    CUR=${DST#"${SUBMISSION_DIR}"}
    echo "${LBLUE}REPLACING MAIN IN${RESET}: ${CUR}"

    DONE=$(grep "//NEW_MAIN" ${DST})
    if [ -z ${DONE} ] ; then
        echo "${YEL}Main has already been replaced${RESET}"
    fi

    # Put the string "//NEW_MAIN" above the lines that contain "Old_Main"
    sed -i '/^.* Main.*/i \/\/NEW_MAIN\n' ${DST}

    # Rename Main as Old_Main
    sed -i 's/Main/Old_Main/' ${DST}

    # Put the content of the ${SRC_FILE} below the lines that contain "//NEW_MAIN"
    sed -i "/\/\/NEW_MAIN/r${SRC_FILE}" ${DST}

    # Remove the useless comment
    #sed -i "/\/\/NEW_MAIN/d" ${DST}
done
