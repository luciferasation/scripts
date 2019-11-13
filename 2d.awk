#Usage: awk -f 2d.awk -v temperature=298.15 data.xvg > pmf.dat
#In the output, the unit for free energy difference is kcal/mol. The first colu-
#mn of data.xvg should be time, which however has nothing to do with the calcu-
#lation of free energy difference. The second column of data.xvg will be plotted
#as horizontal coordinates. The third colum of data.xvg will be plotted as ver-
#tical coordinates. Horizontal coordinates are associated with the variables in 
#this script whose names start with "x". Vertical coordinates are associated wi-
#th the variables in this script whose names start with "y". To visualize pmf.da
#t, it is recommended to use pm3d in gnuplot and then get the result of free e-
#nergy landscapes in the form of a heatmap. The unit of the input value for tem-
#perature is Kelvin. Change the values of xstart, ystart, xend and yend based on
#the ranges of the second and the third column in data.xvg. Change the values of
#xbin and ybin according to your needs.
BEGIN {
xstart = -180.0;
ystart = -180.0;
xend = 180.0;
yend = 180.0;
xbin = 360;
ybin = 360;
xspacing = (xend - xstart) / xbin;
yspacing = (yend - ystart) / ybin;
}
{
    xvalue = ($2 - xstart) / xspacing;
    xint = int(xvalue);
    yvalue = ($3 - ystart) / yspacing;
    yint = int(yvalue);
    if (xvalue == 0 && yvalue == 0)
    {
        if ((1,1) in occur)
            occur[1,1] += 1;
        else
            occur[1,1] = 1;
    }
    if (xvalue == 0 && yvalue != 0)
    {
        if (yvalue != yint)
        {
            if ((1,yint + 1) in occur)
                occur[1,yint + 1] += 1;
            else
                occur[1,yint + 1] = 1;
        }
        else
        {
            if ((1,yint) in occur)
                occur[1,yint] += 1;
            else
                occur[1,yint] = 1;
        }
    }
    if (xvalue != 0 && yvalue == 0)
    {
        if (xvalue != xint)
        {
            if ((xint + 1,1) in occur)
                occur[xint + 1,1] += 1;
            else
                occur[xint + 1,1] = 1;
        }
        else
        {
            if ((xint,1) in occur)
                occur[xint,1] += 1;
            else
                occur[xint,1] = 1;
        }
    }
    if (xvalue != 0 && yvalue != 0)
    {
        if (xvalue != xint)
        {
            if (yvalue != yint)
            {
                if ((xint + 1,yint + 1) in occur)
                    occur[xint + 1,yint + 1] += 1;
                else
                    occur[xint + 1,yint + 1] = 1;
            }
            else
            {
                if ((xint + 1,yint) in occur)
                    occur[xint + 1,yint] += 1;
                else
                    occur[xint + 1,yint] = 1;
            }
        }
        else
        {
            if (yvalue != yint)
            {
                if ((xint,yint + 1) in occur)
                    occur[xint,yint + 1] += 1;
                else
                    occur[xint,yint + 1] = 1;
            }
            else
            {
                if ((xint,yint) in occur)
                    occur[xint,yint] += 1;
                else
                    occur[xint,yint] = 1;
            }
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
    for (m = 1; m <= ybin; m++)
    {
        if ((l,m) in occur)
        {
            tnum = occur[l,m];
            if (tnum > maxnum)
                maxnum = tnum;
            if (tnum < minnum)
                minnum = tnum;
        }
    }
}
#I arbitrarily set the unexplored region as being explored 1/1000000 times the 
#mostly visted region at the convenience of plotting.
if (minnum / maxnum <= 0.000001)
    printf("For %s, the minimal number in a bin is %d and the maximal number in a bin is %d. Adjust the settings to make the ratio of the minimal number to the maximal number higher than 1/1000000. You can increase xbin and ybin in this script first.", FILENAME, minnum, maxnum);
else
{
    for (u = 1; u <= xbin; u++)
    {
        for (v = 1; v <= ybin; v++)
        {
            if ((u,v) in occur)
            {
                cnum = occur[u,v];
                freeenergy = -R * temperature * log(cnum / maxnum) / 4184.0;
                printf("%9.3f%9.3f%9.3f\n", xstart + xspacing * (u - 0.5), ystart + yspacing * (v - 0.5), freeenergy);
            }
            else
            {
                freeenergy = -R * temperature * log(0.000001) / 4184.0;
                printf("%9.3f%9.3f%9.3f\n", xstart + xspacing * (u - 0.5), ystart + yspacing * (v - 0.5), freeenergy);
            }
        }
        printf("\n");
    }
}
}


