# Usage: gnuplot 2d-png.plt
# On Windows you can just double click. This script is for plotting 2D free ene-
# rgy landscape. The script was initially designed for 2 dihedral angles as col-
# lective variables. Based on your data, please adjust the values of MinFreeEner
# gy and MaxFreeEnergy respectively. Usually, MinFreeEnergy is set at zero. If 
# you did a normal molecular dynamics simulation, I personally suggest that MaxF
# reeEnergy be set between the free energy value of unvisited regions and the 
# highest free energy value of visited regions. The free energy value of unvi-
# sited regions is usually the highest value in the third column and can appear 
# multiple times in a file. The highest free energy value of visited regions is 
# usually the second highest value in the third column, if the highest value in 
# the third column appears multiple times. However, if you used certain enhanced
# sampling technique like metadynamics, adaptive biasing force, etc., you might 
# find that the highest value of the third column only appears once. In this ca-
# se, there is no unvisited region. You should set MaxFreeEnergy right at or a 
# little bit higher than the highest value of the third column. For convenience 
# of plotting, MaxFreeEnergy should be set an integer number because MinFreeEner
# gy is set at zero and FreeEnergyIncrement is set as 1 for plotting contour li-
# nes.
MinFreeEnergy=0.
MaxFreeEnergy=6.
FreeEnergyIncrement=1.
set terminal pngcairo
set size square

set encoding utf8
set encoding iso_8859_1

set key top right samplen 1.0
unset key

set offset 0,0,0,0
do for [i=3:(MaxFreeEnergy-MinFreeEnergy+2)] { set style line i linecolor rgb 'black' linetype 1}
set style increment userstyles
set cntrparam levels incremental MinFreeEnergy+FreeEnergyIncrement,FreeEnergyIncrement,MaxFreeEnergy-FreeEnergyIncrement

set yrange [-180:180]
set xrange [-180:180]
set ytics 60 nomirror
set xtics 60 nomirror
set mytics 2
set mxtics 2
set ylabel "{/Symbol y}" font "Helvetica.24"
set xlabel "{/Symbol f}" font "Helvetica.24"

set hidden3d
set pm3d map
set pm3d explicit
set pm3d interpolate 0,0
set contour base
set colorbox vertical user size 0.04,0.6 origin 0.78,0.2
set cbrange [MinFreeEnergy:MaxFreeEnergy]
set cbtics 1
set cblabel "kcal/mol" rotate by 0 offset -4,9.5 font "Helvetica.20"
set palette defined (0 "white", 1 "blue", 2 "yellow", 3 "red")

set output "pmf.png"

splot "pmf.dat"

