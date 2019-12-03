BEGIN {
FS = " ";
numAtom = split(l,atom);
numBond = split(b,bond);
numAngle = split(a,angle);
numDihedral = split(d,dihedral);
numTpa = split(t,tpa);
numBond = numBond/2;
numAngle = numAngle/3;
numDihedral = numDihedral/4;
numTpa = numTpa/6;
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
}
{
    for (i=1;i<=numAtom;i++)
    {
        Atom[i,1] = $(4*i-2);
        Atom[i,2] = $(4*i-1);
        Atom[i,3] = $(4*i);
    }
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
function fbond(b1,b2,    x1,y1,z1,x2,y2,z2)
{
    x1 = Atom[b1,1];
    y1 = Atom[b1,2];
    z1 = Atom[b1,3];
    x2 = Atom[b2,1];
    y2 = Atom[b2,2];
    z2 = Atom[b2,3];
    return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
}
#The units of the results given by function fangle are in degrees.
function fangle(a1,a2,a3,    x1,y1,z1,x2,y2,z2,x3,y3,z3,cosangle)
{
    x1 = Atom[a1,1];
    y1 = Atom[a1,2];
    z1 = Atom[a1,3];
    x2 = Atom[a2,1];
    y2 = Atom[a2,2];
    z2 = Atom[a2,3];
    x3 = Atom[a3,1];
    y3 = Atom[a3,2];
    z3 = Atom[a3,3];
    cosangle = ((x1-x2)*(x3-x2)+(y1-y2)*(y3-y2)+(z1-z2)*(z3-z2))/sqrt(((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2))*((x3-x2)*(x3-x2)+(y3-y2)*(y3-y2)+(z3-z2)*(z3-z2)));
    return 57.29577951*atan2(sqrt(1-cosangle*cosangle),cosangle);
}
#The units of the results given by function fdihedral are in degrees.
function fdihedral(d1,d2,d3,d4,    x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,norm1,x5,y5,z5,norm2,x6,y6,z6)
{
    x1 = Atom[d1,1];
    y1 = Atom[d1,2];
    z1 = Atom[d1,3];
    x2 = Atom[d2,1];
    y2 = Atom[d2,2];
    z2 = Atom[d2,3];
    x3 = Atom[d3,1];
    y3 = Atom[d3,2];
    z3 = Atom[d3,3];
    x4 = Atom[d4,1];
    y4 = Atom[d4,2];
    z4 = Atom[d4,3];
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
#The units of the results given by function ftwoplaneangle are in degrees.
function ftwoplaneangle(t1,t2,t3,t4,t5,t6,    x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,x5,y5,z5,x6,y6,z6,x7,y7,z7,x8,y8,z8,costwoplaneangle)
{
    x1 = Atom[t1,1];
    y1 = Atom[t1,2];
    z1 = Atom[t1,3];
    x2 = Atom[t2,1];
    y2 = Atom[t2,2];
    z2 = Atom[t2,3];
    x3 = Atom[t3,1];
    y3 = Atom[t3,2];
    z3 = Atom[t3,3];
    x4 = Atom[t4,1];
    y4 = Atom[t4,2];
    z4 = Atom[t4,3];
    x5 = Atom[t5,1];
    y5 = Atom[t5,2];
    z5 = Atom[t5,3];
    x6 = Atom[t6,1];
    y6 = Atom[t6,2];
    z6 = Atom[t6,3];
    x7 = y1*(z3-z2)+y2*(z1-z3)+y3*(z2-z1);
    y7 = z1*(x3-x2)+z2*(x1-x3)+z3*(x2-x1);
    z7 = x1*(y3-y2)+x2*(y1-y3)+x3*(y2-y1);
    x8 = y4*(z6-z5)+y5*(z4-z6)+y6*(z5-z4);
    y8 = z4*(x6-x5)+z5*(x4-x6)+z6*(x5-x4);
    z8 = x4*(y6-y5)+x5*(y4-y6)+x6*(y5-y4);
    costwoplaneangle = (x7*x8+y7*y8+z7*z8)/sqrt((x7*x7+y7*y7+z7*z7)*(x8*x8+y8*y8+z8*z8));
    return 57.29577951*atan2(sqrt(1-costwoplaneangle*costwoplaneangle),costwoplaneangle);
}
