#!/usr/bin/env bash
### This script can extract pyramidalization angles from xyz-format files. The 
### output is pure text and can be easily used by other programs, such as 
### gnuplot. This script relies on an awk script written by me: pyramidalization
### .awk. The awk script should be put in the same directory as this script. The
### awk script relies on certain feature of GNU awk, which is missing in the de-
### fault awk in MacOS. Also, the files to be processed should be put in the sa-
### me directory. This script processes each file with a .xyz file name exten-
### sion in the working directory. The definition of pyramidalization angle can 
### be found at 
### J. Comput. Chem., 33: 2173-2179. https://doi.org/10.1002/jcc.23053

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

help() {
    awk -F'### ' '/^###/ { print $2 }' "$0"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
    exit 1
fi

test -s $script_dir/pyramidalization.awk
if [ $? -ne 0 ]; then
    echo "Missing pyramidalization.awk!"
    exit 1
fi
echo "This script will execute on all of the xyz-format files in the current directory."
echo "If you want to skip any step, type q."
printf "\n"
pf=1
while [ $pf -ne 0 ]
do
    printf "Type in the pyramidalization angles you need. Example inputs are shown below. If you are not interested in any pyramidalization angles, type in q to proceed to the next step.\n1-3-6-2 7-8-9-10\nThe example input will produce two pyramidalization angles in the output. The central carbon atom of the first pyramidalization angle is the 1st atom. The central carbon atom of the second pyramidalization angle is the 7th atom. The 1st atom is bonded to the 3rd atom, the 6th atom, and the 2nd atom respectively. The 7th atom is bonded to the 8th atom, the 9th atom, and the 10th atom respectively.\n"
    read -a pyramidalization
# convert the array to a string
    pl=$( IFS='|'; echo "${pyramidalization[*]}")
    if [ "${pyramidalization[0]}" = "q" ]; then
        pf=0
        np=0
    else
        pf=`echo $pl | awk 'BEGIN { FS="-"; RS="|"; flag=0 } { if(NF!=4) { flag=1; exit 1 } } END { print flag }'`
        if [ $pf -eq 0 ]; then
            np=${#pyramidalization[@]}
        else
            echo "Wrong input!"
        fi
    fi
done
if [ $np -ne 0 ]; then
# replace '-' with space and get a new string to be used by awk
    pg=${pyramidalization[@]//-/ }
else
    pg=0
fi
for file in *.xyz
do
    target=${file%.*}
    if (test -a ./$target.pa) then
        printf "Move %s.pa out of the current directory before running this script." "$target"
        continue
    fi
    num_atom=`head -n 1 $file`
    if [ "$pg" != "0" ]; then
        pm=($pg)
        pz=${pm[0]}
        for (( c=1; c<${#pm[@]}; c++ ))
        do
            if [ ${pm[c]} -gt $pz ]; then
                pz=${pm[c]}
            fi	
        done
        if [ $pz -gt $num_atom ]; then
            printf "There are only %d atoms in %s.\n" "$num_atom" "$file"
            continue
        fi
    fi
    awk -f $script_dir/pyramidalization.awk -v p="$pg" $file $file | column -t > $target.pa
done
