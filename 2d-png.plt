# Usage: gnuplot 2d-png.plt
# On Windows you can just double click. This script is for plotting 2D free ene-
# rgy landscape. Based on your data, please adjust cbrange. The lower bound of 
# cbrange should be the lowest free energy value, usually zero. It is my perso-
# nal advice that you should set the higher bound of cbrange between the free e-
# nergy value of unvisited regions and the highest free energy value of visited 
# regions. The free energy value of unvisited regions is usually the highest va-
# lue in the third column and can be the same in data from different sources. 
# The highest free energy value of visited regions is usually the second highest
# value in the third column.
set terminal pngcairo
set size square

set encoding utf8
set encoding iso_8859_1

set key top right samplen 1.0
unset key

set offset 0,0,0,0
set style line 11 lc rgb '#FF0000' lt 1 lw 3
set style line 12 lc rgb '#0000FF' lt 1 lw 3
set style line 13 lc rgb '#808000' lt 1 lw 3
set style line 14 lc rgb '#000000' lt 1 lw 3
set style line 15 lc rgb '#00FFFF' lt 1 lw 3
set style line 16 lc rgb '#707070' lt 1 lw 3
set style line 17 lc rgb '#909090' lt 1 lw 3

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
set cbrange [0:6]
set cbtics 1
set cblabel "kcal/mol" rotate by 0 offset -4,9.5 font "Helvetica.20"
set palette defined (0 "white", 1 "blue", 2 "yellow", 3 "red")

set output "0.png"

splot "pmf0.dat"

