BEGIN {
FS = " ";
CONVFMT="%.8g"
numBond = split(b,bond);
numAngle = split(a,angle);
numDihedral = split(d,dihedral);
numTpa = split(t,tpa);
maxserial = 0;
for (i = 1; i <= numBond; i++)
    maxserial = (maxserial > +bond[i]) ? maxserial : +bond[i];
for (i = 1; i <= numAngle; i++)
    maxserial = (maxserial > +angle[i]) ? maxserial : +angle[i];
for (i = 1; i <= numDihedral; i++)
    maxserial = (maxserial > +dihedral[i]) ? maxserial : +dihedral[i];
for (i = 1; i <= numTpa; i++)
    maxserial = (maxserial > +tpa[i]) ? maxserial : +tpa[i];
}

# The following commands will only be executed on the 1st frame to extract ele-
# ments.
FNR == NR {
if (FNR == 1)
    numAtom = +$1;
else if (FNR == 2)
    next;
else
{
    atomserial = FNR - 2;
    if (atomserial <= maxserial)
    {
        for (i = 1; i <= numBond; i++)
        {
            if (atomserial == +bond[i])
            {
                atom[atomserial] = $1;
                if (atomserial < maxserial)
                    next;
                break;
            }
        }
        for (i = 1; i <= numAngle; i++)
        {
            if (atomserial in atom)
                break;
            if (atomserial == +angle[i])
            {
                atom[atomserial] = $1;
                if (atomserial < maxserial)
                    next;
                break;
            }
        }
        for (i = 1; i <= numDihedral; i++)
        {
            if (atomserial in atom)
                break;
            if (atomserial == +dihedral[i])
            {
                atom[atomserial] = $1;
                if (atomserial < maxserial)
                    next;
                break;
            }
        }
        for (i = 1; i <= numTpa; i++)
        {
            if (atomserial in atom)
                break;
            if (atomserial == +tpa[i])
            {
                atom[atomserial] = $1;
                if (atomserial < maxserial)
                    next;
                break;
            }
        }
        if (atomserial == maxserial)
        {
            numBond = int(numBond/2);
            numAngle = int(numAngle/3);
            numDihedral = int(numDihedral/4);
            numTpa = int(numTpa/6);
            printf("#");
            for (i=1;i<=numBond;i++)
            {
                for (j=1;j<=2;j++)
                    Bond[i,j] = bond[2*(i-1)+j];
                printf("%s%d-%s%d ", atom[Bond[i,1]], Bond[i,1], atom[Bond[i,2]], Bond[i,2]);
            }
            for (i=1;i<=numAngle;i++)
            {
                for (j=1;j<=3;j++)
                    Angle[i,j] = angle[3*(i-1)+j];
                printf("%s%d-%s%d-%s%d ", atom[Angle[i,1]], Angle[i,1], atom[Angle[i,2]], Angle[i,2], atom[Angle[i,3]], Angle[i,3]);
            }
            for (i=1;i<=numDihedral;i++)
            {
                for (j=1;j<=4;j++)
                    Dihedral[i,j] = dihedral[4*(i-1)+j];
                printf("%s%d-%s%d-%s%d-%s%d ", atom[Dihedral[i,1]], Dihedral[i,1], atom[Dihedral[i,2]], Dihedral[i,2], atom[Dihedral[i,3]], Dihedral[i,3], atom[Dihedral[i,4]], Dihedral[i,4]);
            }
            for (i=1;i<=numTpa;i++)
            {
                for (j=1;j<=6;j++)
                    Tpa[i,j] = tpa[6*(i-1)+j];
                printf("%s%d-%s%d-%s%d-%s%d-%s%d-%s%d ", atom[Tpa[i,1]], Tpa[i,1], atom[Tpa[i,2]], Tpa[i,2], atom[Tpa[i,3]], Tpa[i,3], atom[Tpa[i,4]], Tpa[i,4], atom[Tpa[i,5]], Tpa[i,5], atom[Tpa[i,6]], Tpa[i,6]);
            }
            printf("\n");
            nextfile;
        }
    }
}
next;
}

# The following commands will be executed on all of the frames.
{
    if ((maxserial < numAtom && FNR % (numAtom + 2) > 2 && FNR % (numAtom + 2) <= 2+maxserial) || (maxserial == numAtom && (FNR % (numAtom + 2) > 2 && FNR % (numAtom + 2) < 2+maxserial || FNR % (numAtom + 2) == 0)))
    {
        atomserial = int(FNR % (numAtom + 2) - 2);
        if (atomserial == -2)
            atomserial = numAtom;
#strtonum is a gawk extension.
        if (atomserial in atom)
        {
            coordinate[atomserial,1] = strtonum($2);
            coordinate[atomserial,2] = strtonum($3);
            coordinate[atomserial,3] = strtonum($4);
        }
        if (atomserial == maxserial)
        {
            for (i=1;i<=numBond;i++)
                printf("%.3f ", fbond(Bond[i,1],Bond[i,2]));
            for (i=1;i<=numAngle;i++)
                printf("%.1f ", fangle(Angle[i,1],Angle[i,2],Angle[i,3]));
            for (i=1;i<=numDihedral;i++)
                printf("%.1f ", fdihedral(Dihedral[i,1],Dihedral[i,2],Dihedral[i,3],Dihedral[i,4]));
            for (i=1;i<=numTpa;i++)
                printf("%.1f ", ftwoplaneangle(Tpa[i,1],Tpa[i,2],Tpa[i,3],Tpa[i,4],Tpa[i,5],Tpa[i,6]));
            printf("\n");
        }
    }
}

function fbond(b1,b2,    x1,y1,z1,x2,y2,z2)
{
    x1 = coordinate[b1,1];
    y1 = coordinate[b1,2];
    z1 = coordinate[b1,3];
    x2 = coordinate[b2,1];
    y2 = coordinate[b2,2];
    z2 = coordinate[b2,3];
    return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
}
#The unit of the results given by function fangle is degree.
function fangle(a1,a2,a3,    x1,y1,z1,x2,y2,z2,x3,y3,z3,cosangle)
{
    x1 = coordinate[a1,1];
    y1 = coordinate[a1,2];
    z1 = coordinate[a1,3];
    x2 = coordinate[a2,1];
    y2 = coordinate[a2,2];
    z2 = coordinate[a2,3];
    x3 = coordinate[a3,1];
    y3 = coordinate[a3,2];
    z3 = coordinate[a3,3];
    cosangle = ((x1-x2)*(x3-x2)+(y1-y2)*(y3-y2)+(z1-z2)*(z3-z2))/sqrt(((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2))*((x3-x2)*(x3-x2)+(y3-y2)*(y3-y2)+(z3-z2)*(z3-z2)));
    return 57.29577951*atan2(sqrt(1-cosangle*cosangle),cosangle);
}
#The unit of the results given by function fdihedral is degree.
function fdihedral(d1,d2,d3,d4,    x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,norm1,x5,y5,z5,norm2,x6,y6,z6)
{
    x1 = coordinate[d1,1];
    y1 = coordinate[d1,2];
    z1 = coordinate[d1,3];
    x2 = coordinate[d2,1];
    y2 = coordinate[d2,2];
    z2 = coordinate[d2,3];
    x3 = coordinate[d3,1];
    y3 = coordinate[d3,2];
    z3 = coordinate[d3,3];
    x4 = coordinate[d4,1];
    y4 = coordinate[d4,2];
    z4 = coordinate[d4,3];
    norm1 = sqrt((y1*(z2-z3)+y2*(z3-z1)+y3*(z1-z2))*(y1*(z2-z3)+y2*(z3-z1)+y3*(z1-z2))+(z1*(x2-x3)+z2*(x3-x1)+z3*(x1-x2))*(z1*(x2-x3)+z2*(x3-x1)+z3*(x1-x2))+(x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))*(x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2)));
    x5 = (y1*(z2-z3)+y2*(z3-z1)+y3*(z1-z2))/norm1;
    y5 = (z1*(x2-x3)+z2*(x3-x1)+z3*(x1-x2))/norm1;
    z5 = (x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/norm1;
    norm2 = sqrt((x3-x2)*(x3-x2)+(y3-y2)*(y3-y2)+(z3-z2)*(z3-z2));
    x6 = (y5*(z3-z2)-(y3-y2)*z5)/norm2;
    y6 = (z5*(x3-x2)-(z3-z2)*x5)/norm2;
    z6 = (x5*(y3-y2)-(x3-x2)*y5)/norm2;
    return -57.29577951*atan2(x6*(y2*(z3-z4)+y3*(z4-z2)+y4*(z2-z3))+y6*(z2*(x3-x4)+z3*(x4-x2)+z4*(x2-x3))+z6*(x2*(y3-y4)+x3*(y4-y2)+x4*(y2-y3)),x5*(y2*(z3-z4)+y3*(z4-z2)+y4*(z2-z3))+y5*(z2*(x3-x4)+z3*(x4-x2)+z4*(x2-x3))+z5*(x2*(y3-y4)+x3*(y4-y2)+x4*(y2-y3)));
}
#The unit of the results given by function ftwoplaneangle is degree.
function ftwoplaneangle(t1,t2,t3,t4,t5,t6,    x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,x5,y5,z5,x6,y6,z6,x7,y7,z7,x8,y8,z8,costwoplaneangle)
{
    x1 = coordinate[t1,1];
    y1 = coordinate[t1,2];
    z1 = coordinate[t1,3];
    x2 = coordinate[t2,1];
    y2 = coordinate[t2,2];
    z2 = coordinate[t2,3];
    x3 = coordinate[t3,1];
    y3 = coordinate[t3,2];
    z3 = coordinate[t3,3];
    x4 = coordinate[t4,1];
    y4 = coordinate[t4,2];
    z4 = coordinate[t4,3];
    x5 = coordinate[t5,1];
    y5 = coordinate[t5,2];
    z5 = coordinate[t5,3];
    x6 = coordinate[t6,1];
    y6 = coordinate[t6,2];
    z6 = coordinate[t6,3];
    x7 = y1*(z3-z2)+y2*(z1-z3)+y3*(z2-z1);
    y7 = z1*(x3-x2)+z2*(x1-x3)+z3*(x2-x1);
    z7 = x1*(y3-y2)+x2*(y1-y3)+x3*(y2-y1);
    x8 = y4*(z6-z5)+y5*(z4-z6)+y6*(z5-z4);
    y8 = z4*(x6-x5)+z5*(x4-x6)+z6*(x5-x4);
    z8 = x4*(y6-y5)+x5*(y4-y6)+x6*(y5-y4);
    costwoplaneangle = (x7*x8+y7*y8+z7*z8)/sqrt((x7*x7+y7*y7+z7*z7)*(x8*x8+y8*y8+z8*z8));
    return 57.29577951*atan2(sqrt(1-costwoplaneangle*costwoplaneangle),costwoplaneangle);
}