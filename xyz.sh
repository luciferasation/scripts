#!/bin/bash
### This script is used to convert Gaussian's BOMD output to xyz formats. I have
### only tested it with the situation where the input structure for Gaussian is 
### a transition state. I use the MPFR feature of GNU awk (gawk) in this script 
### to convert the units of length from Bohr to Angstrom. If your computer only 
### has a copy of gawk older than version 4.1.0 or not compiled with MPFR, you 
### need to delete the "-M" parameter after awk commands in this script before 
### running this script. I cannot guarantee the precision of the data in output 
### xyz-format files if the "-M" parameter is deleted. Try another computer if 
### you fail to install a satisfactory version of gawk on your computer. This 
### script relies on an awk script written by me: xyz.awk, which should be put 
### in the same directory as this script. Also, the Gaussian's BOMD output shou-
### ld be put in the same directory.
### Interactive Usage: sh xyz.sh
### Non-Interactive Usage: sh xyz.sh input.out
### For non-interactive usage, the parameter input.out should be replaced with 
### the filename of your Gaussian's BOMD output.
### If you want to convert all Gaussian outputs in the current directory at on-
### ce, you can try one of the commands shown below. However, if some Gaussian 
### outputs in the directory are not produced by BOMD jobs, this script will 
### fail on those Gaussian outputs and you may need to delete the wrongly gene-
### rated xyz-format files manually.
### Batch Mode: find . -maxdepth 1 -name "*.out" -exec sh {} \;
### Batch Mode: find . -maxdepth 1 -name "*.log" -exec sh {} \;
help() {
    awk -F'### ' '/^###/ { print $2 }' "$0"
}

if [[ $# == 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    help
    exit 1
fi

test -s ./xyz.awk
if [ $? -ne 0 ]; then
    echo "Missing xyz.awk!"
    exit 1
fi
if [ ${#1} -gt 0 ]; then
log=$1
else
    echo "Please input the filename of Gaussian's BOMD output."
    read log
fi
if (test -a ./$log) then
    target=${log%.*}
    if (test -a ./$target.xyz) then
        printf "The filename of the output would be %s.xyz while one of the existing files has the same filename. Move %s.xyz out of the current directory before running this script." "$target" "$target"
        exit 1
    fi
#Use degree of freedom to determine the number of atoms.
    num_atom=`grep --max-count=1 "^ Deg. of freedom \{1,\}[1-9][0-9]\{1,\}$\|^ Deg. of freedom \{1,\}[0-9]$" ./$log | awk 'BEGIN { FS = " "} { printf("%d\n", ($4-$4%3)/3+2) }'`
    printf "For %s, there are %d atoms.\n" "$log" "$num_atom"
    bohr2angstrom=0.5291772083
    atom=(`grep --max-count=1 --after-context=$num_atom "^ Charge = \{1,\}[0-9] \{1,\}Multiplicity = \{1,\}[0-9]$" ./$log | awk 'BEGIN { FS = " "} { if($1!="Charge") print $1 }'`)
    grep --no-group-separator --after-context=$(($num_atom + 8)) "^ Summary information for step \{1,\}[1-9][0-9]\{0,\}$" ./$log | awk -f xyz.awk -M -v a="${atom[*]}" b2a="$bohr2angstrom" > $target.xyz
    exit 0
else
    echo "No such Gaussian's BOMD output in the current directory!"
	exit 1
fi
