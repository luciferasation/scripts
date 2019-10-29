# Usage: gnuplot 2d-eps.plt
# On Windows you can just double click. Tis script is for plotting 2D free ener-
# gy landscape.
set terminal postscript eps color rounded enhanced "Helvetica" 18 size 3in, 3in
set terminal postscript eps color solid
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

set output "0.eps"

splot "pmf0.dat"

