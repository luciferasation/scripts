BEGIN {
FS = " ";
numPyramidalization = split(p,pyramidalization);
maxserial = 0;
for (i = 1; i <= numPyramidalization; i++)
    maxserial = (maxserial > pyramidalization[i]) ? maxserial : pyramidalization[i];
}

# The following commands will only be executed on the 1st frame to extract ele-
# ments.
FNR == NR {
if (FNR == 1)
    numAtom = $1;
else
{
    atomserial = FNR - 2;
    if (atomserial <= maxserial)
    {
        if (atomserial in atom)
            next;
        else
        for (i = 1; i <= numPyramidalization; i++)
        {
            if (atomserial == pyramidalization[i])
            {
                atom[atomserial] = $1;
                break;
            }
        }
        if (atomserial == maxserial)
        {
            numPyramidalization = numPyramidalization/4;
            printf("#");
            for (i = 1; i <= numPyramidalization; i++)
            {
                for (j=1;j<=4;j++)
                    P[i,j] = pyramidalization[4*(i-1)+j];
                printf("%s%d-%s%d-%s%d-%s%d ", atom[P[i,1]], P[i,1], atom[P[i,2]], P[i,2], atom[P[i,3]], P[i,3], atom[P[i,4]], P[i,4]);
            }
            printf("\n");
            nextfile;
        }
    }
}
next;
}

# The following commands will be executed on all of the frames.
NF == 4 {
    atomserial = FNR % (numAtom + 2) - 2;
    if (atomserial == -2)
        atomserial = numAtom;
    if (atomserial in atom)
    {
        A[atomserial,1] = $2;
        A[atomserial,2] = $3;
        A[atomserial,3] = $4;
    }
    if (atomserial == maxserial)
    {
        for (i = 1; i <= numPyramidalization; i++)
            printf("%.2f ", thetap(P[i,1],P[i,2],P[i,3],P[i,4]));
        printf("\n");
    }
}

function cosangle(a1,a2,a3,    x1,y1,z1,x2,y2,z2,x3,y3,z3)
{
    x1 = A[a1,1];
    y1 = A[a1,2];
    z1 = A[a1,3];
    x2 = A[a2,1];
    y2 = A[a2,2];
    z2 = A[a2,3];
    x3 = A[a3,1];
    y3 = A[a3,2];
    z3 = A[a3,3];
    return ((x1-x2)*(x3-x2)+(y1-y2)*(y3-y2)+(z1-z2)*(z3-z2))/sqrt(((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2))*((x3-x2)*(x3-x2)+(y3-y2)*(y3-y2)+(z3-z2)*(z3-z2)));
}

# The unit of the results given by function thetap is degree.
function thetap(a1,a2,a3,a4,    cosalpha,cosbeta,cosgamma,squaresinthetap)
{
    cosalpha = cosangle(a2,a1,a3);
    cosbeta = cosangle(a3,a1,a4);
    cosgamma = cosangle(a4,a1,a2);
    squaresinthetap = (2*cosalpha*cosbeta*cosgamma-cosalpha*cosalpha-cosbeta*cosbeta-cosgamma*cosgamma+1)/(-cosalpha*cosalpha-cosbeta*cosbeta-cosgamma*cosgamma+2*(cosalpha*cosbeta+cosbeta*cosgamma+cosgamma*cosalpha)-2*(cosalpha+cosbeta+cosgamma)+3);
    if (squaresinthetap < 1e-6 && squaresinthetap > -1e-6)
        squaresinthetap = 0;
    return 57.29577951*atan2(sqrt(squaresinthetap),sqrt(1-squaresinthetap));
}
