#!/bin/bash

if [ $# != 2 ] ; then
    echo -e "Missing argument."
    echo -e "Usage: ./nunit_correct.sh SUBMISSION_DIRECTORY UNIT_TEST_FILE"
    exit
fi

BLUE="\e[34m"
YELL="\e[33m"
RED="\e[31m"
GREEN="\e[32m"
BLINK="\e[5m"
RESET="\e[0m"

CSC=mcs #csc also works
CSCFLAGS=
NUNIT=tc-next.exe #nunit-gui and nunit-console also worked pre NUnit 3.0
EDITOR=vim # rider / monodevelop or emacs also works
EDITOR_OPTIONS=-p # open all files in multiple tabs
SUBMISSION_DIR=$1
TEST_FILE=$2
SOLUTION_NAME="Conquer"
SRC_FILES="Program.cs Cipher.cs Compress.cs"
REFERENCES="System.Drawing.dll nunit.framework.dll"
NCPS1="${BLINK}>${RESET} "

install_nunit()
{
    echo -e ${BLUE}Installing nunit-console nuget mono packages and TestCentric...${RESET}
    sudo apt install nunit-console
    sudo apt install nunit-gui
    sudo apt install nuget
    sudo apt install mono
    git clone git@github.com:TestCentric/testcentric-gui.git
    PATH=$PATH:${PWD}/TestCentric

    echo -e ${BLUE}Versions:${RESET}
    mono -V | head -1
    nunit-console -? | head -1
    nuget | head -1

    echo -e ${BLUE}Installing NUnit...${RESET}
    #nuget install nunit
    nuget install nunit -version 3.11.0 # Or 1.6.4

    echo -e ${BLUE}Moving nunit.framework.dll to current folder...${RESET}
    mv NUnit.3.11.0/lib/net45/nunit.framework.dll .

    echo -e ${BLUE}Removing NUnit directory...${RESET}
    rm -rf NUnit.3.11.0/
}

help()
{
    echo "--- NUnit Correct (v1.0) ---"
    echo "help, h:      Displays this menu"
    echo "clear:        Clears the screen"
    echo "next, n:      Correct the next student"
    echo "previous, p:  Correct the previous student"
    echo "relaunch, r:  Relaunch nunit"
    echo "quit, q:      Quit nunit correct"
    echo "edit, e:      Launch your prefered editor"
    echo "compile, c:   Compile the project once more"
    echo "tree, t:      Run the tree command at the root of the repo"
    echo "tig:          Run the tig command at the root of the repo"
    echo "gitlog, gl:   Run the git log commang at the root of the repo"
    echo "readme, r:    Display the READMEFILE at the root of the repo"
    echo "display, d:   TODO: Display the specified function"
    echo "FIXME"
    echo "----------------------------"
}

mini_cli()
{
    # Running Nunit for student submission
    (${NUNIT} ${OUTFILE} 2>/dev/null)&
    NUNIT_PID=$!
    while true; do
        printf "${NCPS1}"
        read INPUT
        if [ "${INPUT}" = "help" ] || [ "${INPUT}" = "h" ] ; then
            help
        elif [ "${INPUT}" = "next" ] || [ "${INPUT}" = "n" ] ; then
            IDX=$((IDX + 1))
            break
        elif [ "${INPUT}" = "previous" ] || [ "${INPUT}" = "p" ] ; then
            IDX=$((IDX - 1))
            break
        elif [ "${INPUT}" = "relaunch" ] || [ "${INPUT}" = "r" ] ; then
            kill ${NUNIT_PID}
            (${NUNIT} ${OUTFILE} 2>/dev/null)&
            NUNIT_PID=$!
        elif [ "${INPUT}" = "quit" ] || [ "${INPUT}" = "q" ] ; then
            kill ${NUNIT_PID}
            rm -f ${OUTFILE} ${OUTFILE}.VisualState.xml
            clear
            exit 0
        elif [ "${INPUT}" = "display" ] || [ "${INPUT}" = "d" ] ; then
            echo -e "FIXME"
        elif [ "${INPUT}" = "compile" ] || [ "${INPUT}" = "c" ] ; then
            compile
        elif [ "${INPUT}" = "edit" ] || [ "${INPUT}" = "e" ] ; then
            ${EDITOR} ${EDITOR_OPTIONS} ${SOURCES}
        else
            echo -e "Unknown command, type \"help\" to get the list of commands."
        fi
    done

    kill ${NUNIT_PID}

    # Comment this line to keep the files
    rm -f ${OUTFILE} ${OUTFILE}.VisualState.xml
}

compile()
{
    echo -e ${BLUE}Compiling...${RESET}
    echo -e
    ${CSC} ${CSCFLAGS} ${TEST_FILE} ${SOURCES} ${REFS} -out:${OUTFILE}
    if [ $? -eq 1 ] ; then
        echo -e "${RED}!!! COMPILE ERROR !!!${RESET}"
    fi
}

get_dir_list()
{
    TMP_LIST=$(find ${SUBMISSION_DIR} -maxdepth 1 -mindepth 1 -type d)
    IDX=0

    for DIR in ${TMP_LIST} ; do
        DIR_LIST[IDX]="${DIR}"
        IDX=$((IDX + 1))
    done
}

correct()
{
    get_dir_list
    TOTAL=${#DIR_LIST[@]}
    IDX=0

    while [ ${IDX} -ne ${TOTAL} ] ; do
        STUDENT=$(basename ${DIR_LIST[IDX]})
        echo -e ${BLUE}STUDENT: ${YELL} ${STUDENT} ${RESET} ${IDX}/${TOTAL}
        DIR=${DIR_LIST[IDX]}/${SOLUTION_NAME}/${SOLUTION_NAME}

        SOURCES=$(find ${DIR} -name "*.cs")

        REFS=""
        for REF in ${REFERENCES} ; do
            REFS="${REFS} /r:${REF}"
        done

        OUTFILE="${STUDENT}_${SOLUTION_NAME}.exe"

        compile

        mini_cli

        clear
    done
}

clean()
{
    rm -f TestResult.xml
}

# Initialize the parameters
parse_config()
{
    echo -e "FIXME"
    # FIXME: Parse config file
}

main()
{
    clear
    echo -e ${BLUE}---[NUNIT CORRECT START]---${RESET}
    if [ ! -f nunit.framework.dll ] ; then
        install_nunit
        printf "NUnit framework is now installed "
    else
        printf "NUnit framework was already installed "
    fi
    echo -e "${GREEN}✔${RESET}"
    echo -e "${YELL}${BLINK}Press ENTER to start correction${RESET}"
    read ANSWER
    clear
    correct
    clean
    echo -e ${BLUE}---[NUNIT CORRECT END]---${RESET}
}

main
