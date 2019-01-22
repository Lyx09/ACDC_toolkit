#!/bin/sh


get_zip_name()
{
    NAME="c#-"
    NAME="${NAME}$(echo "$1" | cut -d '-' -f 2)"
    NAME="${NAME}-archives-int2"
    echo ${NAME}
}

clean_dir()
{
    find $1 -name "bin" | xargs rm -rf
    find $1 -name "obj" | xargs rm -rf
}

clean_dir $1
ZIP_NAME=$(get_zip_name $1)
mv $1 ${ZIP_NAME}
zip -r ${ZIP_NAME}.zip ${ZIP_NAME} 1>/dev/null
rm -rf ${ZIP_NAME}

