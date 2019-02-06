#!/bin/sh

CSC=mcs #csc also works
NUNIT=nunit-gui #nunit-console also works

if [ $# != 2 ] ; then
	echo "Missing argument."
	echo "Usage: ./nunit_correct.sh SUBMISSION_DIRECTORY UNIT_TEST_FILE"
	exit
fi

SUBMISSION_DIR=$1
TEST_FILE=$2
SOLUTION_NAME="Basic"
SRC_FILES="Program.cs"

BLUE="\e[34m"
YELL="\e[33m"
RED="\e[31m"
GREEN="\e[32m"
BLINK="\e[5m"
RESET="\e[0m"

install_nunit()
{
	echo ${BLUE}Installing nunit-console nuget and mono packages...${RESET}
	sudo apt install -y nunit-console nuget mono

	echo ${BLUE}Versions:${RESET}
	mono -V | head -1
	nunit-console -? | head -1
	nuget | head -1

	echo ${BLUE}Installing NUnit...${RESET}
	#nuget install nunit
	nuget install nunit -version 2.6.4

	echo ${BLUE}Moving nunit.framework.dll to current folder...${RESET}
	mv NUnit.2.6.4/lib/nunit.framework.dll .

	echo ${BLUE}Removing NUnit directory...${RESET}
	rm -rf NUnit.2.6.4/
}

correct()
{
	DIR_LIST=$(find ${SUBMISSION_DIR} -name Program.cs | grep ${SOLUTION_NAME})
	COUNT=1
	TOTAL=$(echo ${DIR_LIST} | wc -w)

	for DIR in ${DIR_LIST} ; do
		STUDENT=$(dirname ${DIR} | sed -n 's/.*\/\([a-z\-]\+\.[a-z\-]\+\)\/.*/\1/p')
		echo ${BLUE} STUDENT: ${YELL} ${STUDENT} ${RESET} ${COUNT}/${TOTAL}

		SOURCES=""
		for SRC in ${SRC_FILES} ; do
			SOURCES="${SOURCES} $(dirname ${DIR}/${SRC}) "
		done
		OUTFILE="${STUDENT}_${SOLUTION_NAME}.exe"

		echo ${BLUE}Compiling...${RESET}
		echo
		${CSC} ${TEST_FILE} ${SOURCES} /r:nunit.framework.dll -out:${OUTFILE}

		if [ $? -eq 1 ] ; then
			echo "${RED}!!! COMPILE ERROR !!!${RESET}"
			echo "${YELL}${BLINK}Press ENTER to continue or type something to retry${RESET}"
			read ANSWER
			while [ "${ANSWER}" != "" ] ; do
				${CSC} ${TEST_FILE} ${SOURCES} /r:nunit.framework.dll -out:${OUTFILE}
				echo "${YELL}${BLINK}Press ENTER to continue or type something to retry${RESET}"
				read ANSWER
			done
		else

			while true; do

				# Running Nunit for student submission
				(${NUNIT} ${OUTFILE} 2>/dev/null)&

				echo "${YELL}${BLINK}Press ENTER to continue or type something to re-run tests${RESET}"
				read ANSWER
				if [ "${ANSWER}" = "" ] ; then
					break
				fi
			done

			# Comment this line to keep the files
			rm -f ${OUTFILE} ${OUTFILE}.VisualState.xml
		fi
		clear
		COUNT=$((COUNT + 1))
	done
}

clean()
{
	rm nunit.framework.dll
	rm TestResult.xml
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
