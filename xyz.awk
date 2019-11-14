BEGIN {
FS = " ";
PREC = "oct";
num_atom = split(a,atom);
}
/^ Summary / {
    printf("%d\nstep %s  ", num_atom, $5);
}
/^ Time / {
    printf("time: %s fs  ", $3);
}
/^ EKin = / {
    printf("nuclear kinetic energy: %s Hartree  potential energy: %s Hartree  total energy: %s Hartree  ", substr($3,1,length($3) - 1), substr($6,1,length($6) - 1), $9);
}
/^ Total angular / {
    m = index($4,"D");
    j = substr($4,1,m - 1);
    s = substr($4,m + 1,1);
    j1 = substr($4,m + 2,1);
    j2 = substr($4,m + 3);
    if (j2 > 9)
    {
        printf("\nERROR1!\n");
        exit 1;
    }
    j2 = j1 * 10 + j2;
    if (s == "+")
        j = j * (10 ** j2);
    else if (s == "-")
        j = j / (10 ** j2);
    else
    {
        printf("\nERROR2!\n");
        exit 1;
    }
    printf("total angular momentum: %f h-bar\n", j);
}
/^ I= / {
    if ($2 > num_atom)
    {
        printf("\nERROR3!\n");
        exit 1;
    }
    xm = index($4,"D");
    ym = index($6,"D");
    zm = index($8,"D");
    x = substr($4,1,xm - 1);
    y = substr($6,1,ym - 1);
    z = substr($8,1,zm - 1);
    xs = substr($4,xm + 1,1);
    ys = substr($6,ym + 1,1);
    zs = substr($8,zm + 1,1);
    x1 = substr($4,xm + 2,1);
    y1 = substr($6,ym + 2,1);
    z1 = substr($8,zm + 2,1);
    x2 = substr($4,xm + 3);
    y2 = substr($6,ym + 3);
    z2 = substr($8,zm + 3);
    if (x2 > 9 || y2 > 9 || z2 > 9)
    {
        printf("\nERROR4!\n");
        exit 1;
    }
    x2 = x1 * 10 + x2;
    y2 = y1 * 10 + y2;
    z2 = z1 * 10 + z2;
    if (xs == "+")
        x = b2a * x * (10 ** x2);
    else if (xs == "-")
        x = b2a * x / (10 ** x2);
    else
    {
        printf("\nERROR5!\n");
        exit 1;
    }
    if (ys == "+")
        y = b2a * y * (10 ** y2);
    else if (ys == "-")
        y = b2a * y / (10 ** y2);
    else
    {
        printf("\nERROR6!\n");
        exit 1;
    }
    if (zs == "+")
        z = b2a * z * (10 ** z2);
    else if (zs == "-")
        z = b2a * z / (10 ** z2);
    else
    {
        printf("\nERROR7!\n");
        exit 1;
    }
    printf("%s %.8f %.8f %.8f\n",atom[$2],x,y,z);
}
