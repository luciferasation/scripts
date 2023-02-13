#!/usr/bin/env bash
### This script can extract bonds, angles, and dihedrals from xyz-format files. 
### The output is pure text and can be easily used by other programs, such as 
### gnuplot. This script relies on an awk script written by me: extraction.awk.
### The awk script should be put in the same directory as this script. The awk 
### script relies on certain feature of GNU awk, which is missing in the default
### awk in MacOS. Also, the files to be processed should be put in the same di-
### rectory. This script processes each file with a .xyz file name extension in 
### the working directory.
### Usage: sh extraction.sh

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

help() {
    awk -F'### ' '/^###/ { print $2 }' "$0"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    help
    exit 1
fi

test -s $script_dir/extraction.awk
if [ $? -ne 0 ]; then
    echo "Missing extraction.awk!"
    exit 1
fi
echo "This script will execute on all of the xyz-format files in the current directory."
echo "If you want to skip any step, type q."
printf "\n"
bf=1
while [ $bf -ne 0 ]
do
    printf "Type in the distances you need. Example inputs are shown below. If you are not interested in any distances, type in q to proceed to the next step.\n1-2 2-3 6-7\nThe example input will produce the distance between the 1st atom and the 2nd atom, the distance between the 2nd atom and the 3rd atom and the distance between the 6th atom and the 7th atom in the output.\n"
    read -a bond
#convert the array to a string
    bl=$( IFS='|'; echo "${bond[*]}")
    if [ "${bond[0]}" = "q" ]; then
        bf=0
        nb=0
    else
        bf=`echo $bl | awk 'BEGIN { FS="-"; RS="|"; flag=0 } { if(NF!=2) { flag=1; exit 1 } } END { print flag }'`
        if [ $bf -eq 0 ]; then
            nb=${#bond[@]}
        else
            echo "Wrong input!"
        fi
    fi
done
if [ $nb -ne 0 ]; then
# replace '-' with space and get a new string to be used by awk
    bg=${bond[@]//-/ }
else
    bg=0
fi
af=1
while [ $af -ne 0 ]
do
    printf "Type in the angles you need. Example inputs are shown below. If you are not interested in any angles, type in q to proceed to the next step.\n1-2-5 2-3-1\nThe example input will produce the angle of the 1st atom, the 2nd atom and the 5th atom and the angle of the 2nd atom , the 3rd atom and the 1st atom in the output.\n"
    read -a angle
#convert the array to a string
    al=$( IFS='|'; echo "${angle[*]}")
    if [ "${angle[0]}" = "q" ]; then
        af=0
        na=0
    else
        af=`echo $al | awk 'BEGIN { FS="-"; RS="|"; flag=0 } { if(NF!=3) { flag=1; exit 1 } } END { print flag }'`
        if [ $af -eq 0 ]; then
            na=${#angle[@]}
        else
            echo "Wrong input!"
        fi
    fi
done
if [ $na -ne 0 ]; then
# replace '-' with space and get a new string to be used by awk
    ag=${angle[@]//-/ }
else
    ag=0
fi
df=1
while [ $df -ne 0 ]
do
    printf "Type in the dihedrals you need. Example inputs are shown below. If you are not interested in any dihedrals, type in q to proceed to the next step.\n1-3-6-2 3-6-1-4\nThe example input will produce the dihedral of the 1st atom, the 3rd atom, the 6th atom and the 2nd atom and the dihedral of the 3rd atom, the 6th atom, the 1st atom and the 4th atom in the output.\n"
    read -a dihedral
#convert the array to a string
    dl=$( IFS='|'; echo "${dihedral[*]}")
    if [ "${dihedral[0]}" = "q" ]; then
        df=0
        nd=0
    else
        df=`echo $dl | awk 'BEGIN { FS="-"; RS="|"; flag=0 } { if(NF!=4) { flag=1; exit 1 } } END { print flag }'`
        if [ $df -eq 0 ]; then
            nd=${#dihedral[@]}
        else
            echo "Wrong input!"
        fi
    fi
done
if [ $nd -ne 0 ]; then
# replace '-' with space and get a new string to be used by awk
    dg=${dihedral[@]//-/ }
else
    dg=0
fi
tf=1
while [ $tf -ne 0 ]
do
    printf "Type in the two-plane-angles you need. Example inputs are shown below. If you are not interested in any two-plane-angles, type in q to proceed to the next step.\n1-2-3-4-5-6 2-3-4-5-6-7\nThe example input will produce the angle of the plane determined by the 1st atom, the 2nd atom and the 3rd atom and the plane determined by the 4th atom, the 5th atom and the 6th atom and the angle between the plane determined by the 2nd atom, the 3rd atom and the 4th atom and the plane determined by the 5th atom, the 6th atom and the 7th atom in the output.\n"
    read -a twoplaneangle
#convert the array to a string
    tl=$( IFS='|'; echo "${twoplaneangle[*]}")
    if [ "${twoplaneangle[0]}" = "q" ]; then
        tf=0
        nt=0
    else
        tf=`echo $tl | awk 'BEGIN { FS="-"; RS="|"; flag=0 } { if(NF!=6) { flag=1; exit 1 } } END { print flag }'`
        if [ $tf -eq 0 ]; then
            nt=${#twoplaneangle[@]}
        else
            echo "Wrong input!"
        fi
    fi
done
if [ $nt -ne 0 ]; then
# replace '-' with space and get a new string to be used by awk
    tg=${twoplaneangle[@]//-/ }
else
    tg=0
fi
for file in *.xyz
do
    target=${file%.*}
    if (test -a ./$target.dat) then
        printf "Move %s.dat out of the current directory before running this script." "$target"
        continue
    fi
    num_atom=`head -n 1 $file`
    if [ "$bg" != "0" ]; then
        bm=($bg)
        bz=${bm[0]}
        for (( c=1; c<${#bm[@]}; c++ ))
        do
            if [ ${bm[c]} -gt $bz ]; then
                bz=${bm[c]}
            fi	
        done
        if [ $bz -gt $num_atom ]; then
            printf "There are only %d atoms in %s.\n" "$num_atom" "$file"
            continue
        fi
    fi
    if [ "$ag" != "0" ]; then
        am=($ag)
        az=${am[0]}
        for (( c=1; c<${#am[@]}; c++ ))
        do
            if [ ${am[c]} -gt $az ]; then
                az=${am[c]}
            fi	
        done
        if [ $az -gt $num_atom ]; then
            printf "There are only %d atoms in %s.\n" "$num_atom" "$file"
            continue
        fi
    fi
    if [ "$dg" != "0" ]; then
        dm=($dg)
        dz=${dm[0]}
        for (( c=1; c<${#dm[@]}; c++ ))
        do
            if [ ${dm[c]} -gt $dz ]; then
                dz=${dm[c]}
            fi	
        done
        if [ $dz -gt $num_atom ]; then
            printf "There are only %d atoms in %s.\n" "$num_atom" "$file"
            continue
        fi
    fi
    if [ "$tg" != "0" ]; then
        tm=($tg)
        tz=${tm[0]}
        for (( c=1; c<${#tm[@]}; c++ ))
        do
            if [ ${tm[c]} -gt $tz ]; then
                tz=${tm[c]}
            fi	
        done
        if [ $tz -gt $num_atom ]; then
            printf "There are only %d atoms in %s.\n" "$num_atom" "$file"
            continue
        fi
    fi
#"1 file, 2 passes" trick from http://datafix.com.au/BASHing/2019-07-12.html
    awk -f $script_dir/extraction.awk -v b="$bg" -v a="$ag" -v d="$dg" -v t="$tg" $file $file | column -t > $target.dat
done
