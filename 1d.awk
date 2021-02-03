#Usage: awk -f 1d.awk -v temperature=298.15 data.xvg > pmf.dat
#In the output, the unit for free energy difference is kcal/mol. The first colu-
#mn of data.xvg should be time, which however has nothing to do with the calcu-
#lation of free energy difference. The second column of data.xvg should be the 
#value of the collective variable. The unit of the input value for temperature 
#is Kelvin. Change the values of xstart, xend based on the ranges of the second 
#column in data.xvg. Change the values of xbin according to your needs.
BEGIN {
xstart = -180.0;
xend = 180.0;
xbin = 360;
xspacing = (xend - xstart) / xbin;
}
{
    xvalue = ($2 - xstart) / xspacing;
    xint = int(xvalue);
    if (xvalue == 0)
    {
        if (1 in occur)
            occur[1] += 1;
        else
            occur[1] = 1;
    }
    if (xvalue != 0)
    {
        if (xvalue != xint)
        {
            label = xint + 1;
            if (label in occur)
                occur[label] += 1;
            else
                occur[label] = 1;
        }
        else
        {
            if (xint in occur)
                occur[xint] += 1;
            else
                occur[xint] = 1;
        }
    }
}
END {
#Gas constant in unit of J K^-1 mol^-1.
R = 8.31446261815324;
maxnum = 1;
minnum = FNR;
for (l = 1; l <= xbin; l++)
{
    if (l in occur)
    {
        tnum = occur[l];
        if (tnum > maxnum)
            maxnum = tnum;
        if (tnum < minnum)
            minnum = tnum;
    }
}
#I arbitrarily set the unexplored region as being explored 1/1000000 times the 
#mostly visted region at the convenience of plotting.
if (minnum / maxnum <= 0.000001)
    printf("For %s, the minimal number in a bin is %d and the maximal number in a bin is %d. Adjust the settings to make the ratio of the minimal number to the maximal number higher than 1/1000000. You can increase xbin in this script first.", FILENAME, minnum, maxnum);
else
{
    for (u = 1; u <= xbin; u++)
    {
        if (u in occur)
        {
            cnum = occur[u];
            freeenergy = -R * temperature * log(cnum / maxnum) / 4184.0;
            printf("%9.3f%9.3f\n", xstart + xspacing * (u - 0.5), freeenergy);
        }
        else
        {
            freeenergy = -R * temperature * log(0.000001) / 4184.0;
            printf("%9.3f%9.3f\n", xstart + xspacing * (u - 0.5), freeenergy);
        }
    }
}
}
