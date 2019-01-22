#!/bin/sh

# A Shell script that fetches the repositories of all students
# whose login are in $login_file
#TODO Make a better parser

FRED="\e[31m"
FBLU="\e[34m"
FGRN="\e[32m"
BBLU="\e[44m"
OGN="\e[0m"

rm -f no_clone.txt
rm -f no_commit.txt

sshkey_location=~/.ssh/id_rsa
ssh-add $sshkey_location  #avoid typing your password everytime

login_file="i2_list.txt"
if [ "$1" != "" ] ; then
    login_file="$1"
fi

tp_name="git@git.cri.epita.fr:p/2023-sup-tp/csharp-tp3"
if [ "$2" != "" ] ; then
    tp_name="$2"
fi

dir_name=$(echo "$tp_name" | cut -d '/' -f 3)
if [ "$3" != "" ] ; then
    dir_name="$3"
fi

nb_student=$(wc -l "$login_file" | cut -d ' ' -f 1)
current=1

mkdir "$dir_name" 2> /dev/null
nb_cl=0
nb_pl=0
nb_no_cl=0
nb_no_ps=0
nb_err=0
root=$(pwd)

while IFS="" read -r login || [ -n "$login" ]
do
    percent=$(( current * 100 / nb_student ))
    printf "[ $FBLU%3s/%s (%3s%%)$OGN]" "$current" "$nb_student" "$percent"

    dir_log=""$dir_name"/"$login""
    if [ -d "$dir_log" ] ; then
        printf "[ PULLED ] %36s: " "$login"
        cd "$dir_log" 
        git pull > /dev/null 2> /dev/null
        ret=$?
        if [ $ret -eq 1 ] ; then
            printf "${FRED}Never pushed${OGN}\n"
            echo "$login" >> "$root"/no_commit.txt
            nb_no_ps=$((nb_no_ps + 1))
            nb_pl=$((nb_pl + 1))
        elif [ $ret -ne 0 ] ; then
            printf "${FRED}ERROR${OGN}\n"
            nb_err=$((nb_err + 1))
        else
            printf "Pulling commits\n"
            nb_pl=$((nb_pl + 1))
        fi

        cd "$root"
    else
        printf "[ CLONED ] %36s: " "$login"
        git clone -q ""$tp_name"-"$login"" "$dir_log" > /dev/null 2> /dev/null
        ret=$?
        if [ $ret -eq 128 ] ; then
            printf "${FRED}Never cloned${OGN}\n"
            nb_no_cl=$((nb_no_cl + 1))
            echo "$login" >> "$root"/no_clone.txt
        elif [ $ret -ne 0 ] ; then
            printf "${FRED}ERROR${OGN}\n"
            nb_err=$((nb_err + 1))
        else
            printf "Cloning repo\n"
            nb_cl=$((nb_cl + 1))
        fi
    fi
    current=$((current + 1))
done < "$login_file"

printf "[ DONE ] Script finished.\n"
printf " --- Summary ---\n"
printf "[ CLON ] %s repository cloned. %s student never cloned: dumping list...\n" "$nb_cl" "$nb_no_cl"
printf "[ PULL ] %s repository pulled including %s with no commit: dumping list...\n" "$nb_pl" "$nb_no_ps"
printf "[ ERRO ] %s other error(s) were encountered\n" "$nb_err"
printf " --- End of Summary ---\n"

exit 0;
