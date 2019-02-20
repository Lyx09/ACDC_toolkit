#!/bin/sh

if [ $# != 2 ] ; then
    echo "Missing argument."
    echo "Usage: ./nunit_correct.sh SUBMISSION_DIRECTORY UNIT_TEST_FILE"
    exit
fi

BLUE="\e[34m"
YELL="\e[33m"
RED="\e[31m"
GREEN="\e[32m"
BLINK="\e[5m"
RESET="\e[0m"

CSC=msc #csc also works
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
    echo ${BLUE}Installing nunit-console nuget mono packages and TestCentric...${RESET}
    sudo apt install nunit-console
    sudo apt install nunit-gui
    sudo apt install nuget
    sudo apt install mono
    git clone git@github.com:TestCentric/testcentric-gui.git
    PATH=$PATH:${PWD}/TestCentric

    echo ${BLUE}Versions:${RESET}
    mono -V | head -1
    nunit-console -? | head -1
    nuget | head -1

    echo ${BLUE}Installing NUnit...${RESET}
    #nuget install nunit
    nuget install nunit -version 3.11.0 # Or 1.6.4

    echo ${BLUE}Moving nunit.framework.dll to current folder...${RESET}
    mv NUnit.3.11.0/lib/net45/nunit.framework.dll .

    echo ${BLUE}Removing NUnit directory...${RESET}
    rm -rf NUnit.3.11.0/
}

help()
{
    echo "--- NUnit Correct (v1.0) ---"
    echo "help, h:      Displays this menu"
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
            echo "FIXME"
        elif [ "${INPUT}" = "compile" ] || [ "${INPUT}" = "c" ] ; then
            compile
        elif [ "${INPUT}" = "edit" ] || [ "${INPUT}" = "e" ] ; then
            ${EDITOR} ${EDITOR_OPTIONS} ${SOURCES}
        else
            echo "Unknown command, type \"help\" to get the list of commands."
        fi
    done

    kill ${NUNIT_PID}

    # Comment this line to keep the files
    rm -f ${OUTFILE} ${OUTFILE}.VisualState.xml
}

compile()
{
    ${CSC} ${CSCFLAGS} ${TEST_FILE} ${SOURCES} ${REFS} -out:${OUTFILE}
}

correct()
{
    DIR_LIST=$(find ${SUBMISSION_DIR} -name Program.cs | grep ${SOLUTION_NAME})
    COUNT=1
    TOTAL=$(echo ${DIR_LIST} | wc -w)

    for DIR in ${DIR_LIST} ; do
        STUDENT=$(dirname ${DIR} | sed -n 's/.*\/\([a-z\-]\+\.[a-z\-]\+\)\/.*/\1/p')
        echo ${BLUE}STUDENT: ${YELL} ${STUDENT} ${RESET} ${COUNT}/${TOTAL}

        SOURCES=""
        for SRC in ${SRC_FILES} ; do
            SOURCES="${SOURCES} $(dirname ${DIR})/${SRC}"
        done

        REFS=""
        for REF in ${REFERENCES} ; do
            REFS="${REFS} /r:${REF}"
        done

        OUTFILE="${STUDENT}_${SOLUTION_NAME}.exe"

        echo ${BLUE}Compiling...${RESET}
        echo
        compile

        if [ $? -eq 1 ] ; then
            echo "${RED}!!! COMPILE ERROR !!!${RESET}"
        fi
        mini_cli
        clear
        COUNT=$((COUNT + 1))
    done
}

clean()
{
    rm -f TestResult.xml
}

# Initialize the parameters
parse_config()
{
    echo "FIXME"
    # FIXME: Parse config file
}

main()
{
    clear
    echo ${BLUE}---[NUNIT CORRECT START]---${RESET}
    if [ ! -f nunit.framework.dll ] ; then
        install_nunit
        printf "NUnit framework is now installed "
    else
        printf "NUnit framework was already installed "
    fi
    echo "${GREEN}✔${RESET}"
    echo "${YELL}${BLINK}Press ENTER to start correction${RESET}"
    read ANSWER
    clear
    correct
    clean
    echo ${BLUE}---[NUNIT CORRECT END]---${RESET}
}

main
