#!/bin/sh

PASS="I'm a cryptomancer !"
READMES=$(find $1 -iname '*README*')
for FILE in ${READMES}; do
	if [ "$(grep ${PASS} ${FILE})" != "" ] ; then
		LOGIN=$(echo $(dirname ${FILE}))
		LOGIN=${LOGIN#"$1/"}
		echo ${LOGIN}
	fi
done
