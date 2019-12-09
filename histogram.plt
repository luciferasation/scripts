# Usage: gnuplot histogram.plt
# On Windows you can just double click. This script is for plotting histograms. 
# In data.dat file, you only need to list one column of original data. This sc-
# ript will automatically count the number of data points in each bin. Adjust 
# the max, min variables in this script according to the range of data in data.d
# at file.
n=100 #number of intervals
max=3. #max value
min=-3. #min value
width=(max-min)/n #interval width
#function used to map a value to the intervals
hist(x,width)=width*floor(x/width)+width/2.0
set boxwidth width*0.9
set style fill solid 0.5 # fill style

#count and plot
plot "data.dat" u (hist($1,width)):(1.0) smooth freq w boxes lc rgb"green" notitle
