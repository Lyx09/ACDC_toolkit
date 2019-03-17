#!/bin/bash

if [ $# != 3 ] ; then
    echo -e "Missing argument."
    echo -e "Usage: ./crun.sh SUBMISSION_DIRECTORY SOLUTION_NAME UNIT_TEST_FILE"
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
EDITOR=vim # rider / monodevelop or emacs also works
EDITORFLAGS=-p # open all files in multiple tabs
RUNNER=tc-next.exe # nunit-gui and nunit-console also worked pre NUnit 3.0
CPS1="${BLINK}>${RESET} "

SUBMISSION_DIR=$1
SOLUTION_NAME=$2
TEST_FILE=$3
REFERENCES="nunit.framework.dll System.Drawing.dll"

trap quit SIGINT SIGTERM
bind -x '"\C-l": clear' # not working

install_nunit()
{
    echo -e ${BLUE}Installing nunit-console nuget mono packages and TestCentric...${RESET}
    sudo apt install nunit-console
    sudo apt install nunit-gui
    sudo apt install nuget
    sudo apt install mono

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
    echo "clear:         Clears the screen"
    echo "command CMD:   TODO: Executes the command at the root"
    echo "compile, c:    Compile the project once more"
    echo "display, d:    TODO: Display the specified function"
    echo "edit, e:       Launch your prefered editor"
    echo "gitlog, gl:    Run the git log commang at the root of the repo"
    echo "help, h:       Displays this menu"
    echo "info, i:       Displays info about the current student"
    echo "jump #, j #:   Jumps to the specified submission"
    echo "list, l:       Lists the submission and their associated number"
    echo "next, n:       Correct the next student"
    echo "previous, p:   Correct the previous student"
    echo "quit, exit, q: Quit nunit correct"
    echo "readme:        Display the README file at the root of the repo"
    echo "relaunch, r:   Relaunch nunit"
    echo "tig:           Run the tig command at the root of the repo"
    echo "tree, t:       Run the tree command at the root of the repo"
    echo "----------------------------"
}

quit()
{
    kill ${NUNIT_PID}
    rm -f ${OUTFILE} ${OUTFILE}.VisualState.xml
    clear
    exit 0
}

mini_cli()
{
    # Running Nunit for student submission if compile passed
    if [ $? -eq 0 ] ; then
        (${RUNNER} ${OUTFILE} 2>/dev/null)&
    fi
    NUNIT_PID=$!
    while true; do
        printf "${CPS1}"
        read FULL_INPUT
        INPUT=$(echo "${FULL_INPUT}" | cut -d " " -f 1 )
        if [ "${INPUT}" = "help" ] || [ "${INPUT}" = "h" ] ; then
            help
        elif [ "${INPUT}" = "clear" ] ; then
            clear
        elif [ "${INPUT}" = "info" ] || [ "${INPUT}" = "i" ] ; then
            echo -e ${BLUE}STUDENT: ${YELL} ${STUDENT} ${RESET} ${IDX}/$((TOTAL - 1))
        elif [ "${INPUT}" = "next" ] || [ "${INPUT}" = "n" ] ; then
            IDX=$((IDX + 1))
            break
        elif [ "${INPUT}" = "previous" ] || [ "${INPUT}" = "p" ] ; then
            if [ ${IDX} -eq 0 ] ; then
                echo "No previous submission"
            else
                IDX=$((IDX - 1))
                break
            fi
        elif [ "${INPUT}" = "relaunch" ] || [ "${INPUT}" = "r" ] ; then
            kill ${NUNIT_PID}
            (${RUNNER} ${OUTFILE} 2>/dev/null)&
            NUNIT_PID=$!
        elif [ "${INPUT}" = "quit" ] || [ "${INPUT}" = "q" ] || [ "${INPUT}" = "exit" ]; then
            quit
        elif [ "${INPUT}" = "display" ] || [ "${INPUT}" = "d" ] ; then
            echo -e "FIXME"
        elif [ "${INPUT}" = "compile" ] || [ "${INPUT}" = "c" ] ; then
            compile
        elif [ "${INPUT}" = "edit" ] || [ "${INPUT}" = "e" ] ; then
            ${EDITOR} ${EDITORFLAGS} ${SOURCES}
        elif [ "${INPUT}" = "tig" ] ; then
            cd ${DIR_LIST[IDX]}; tig; cd - 1>/dev/null
        elif [ "${INPUT}" = "list" ] || [ "${INPUT}" = "l" ] ; then
            for IT in "${!DIR_LIST[@]}"; do
                printf "%s\t%s\n" "${IT}" "$(basename ${DIR_LIST[${IT}]})"
            done
        elif [ "${INPUT}" = "jump" ] || [ "${INPUT}" = "j" ] ; then
            # Cannot be put in a separate function since it uses break
            NB=$(echo ${FULL_INPUT} | cut -d " " -f 2)
            if [ ${NB} = "j" ] ; then
                echo "Please specify a number to jump to. See: list"
            elif ! [[ "${NB}" =~ ^[0-9]+$ ]] ; then
                echo "${NB} is not a number"
            elif [ ${NB} -gt ${TOTAL} ] ; then
                echo "No submission match ${NB}. See: list"
            else
                IDX=${NB}
                break
            fi
        elif [ "${INPUT}" = "tree" ] || [ "${INPUT}" = "t" ] ; then
            cd ${DIR_LIST[IDX]}; tree; cd - 1>/dev/null
        elif [ "${INPUT}" = "gitlog" ] || [ "${INPUT}" = "gl" ] ; then
            cd ${DIR_LIST[IDX]}; git log; cd - 1>/dev/null
        elif [ "${INPUT}" = "readme" ] ; then
            cd ${DIR_LIST[IDX]}; find -iname "*README*" -type f | xargs less; cd -
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
    echo
    ${CSC} ${CSCFLAGS} ${TEST_FILE} ${SOURCES} ${REFS} -out:${OUTFILE}
    if [ $? -eq 1 ] ; then
        echo -e "${RED}!!! COMPILE ERROR !!!${RESET}"
        false
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
        echo -e ${BLUE}STUDENT: ${YELL} ${STUDENT} ${RESET} ${IDX}/$((TOTAL - 1))
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

    # Adding test centric to your path
    # Location of this script
    SCRIPT_LOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    TEST_CENTRIC=${SCRIPT_LOC}/TestCentric/
    echo ${TEST_CENTRIC}
    PATH=${PATH}:${TEST_CENTRIC}

    if [ ! -f nunit.framework.dll ] ; then
        install_nunit
        printf "NUnit framework is now installed "
    else
        printf "NUnit framework was already installed "
    fi
    echo -e "${GREEN}✔${RESET}"
    echo -e "${YELL}${BLINK}Press ENTER to start correction: Good luck!${RESET}"
    read ANSWER
    clear
    correct
    clean
    echo -e ${BLUE}---[NUNIT CORRECT END]---${RESET}
}

time main
