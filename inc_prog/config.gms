option lp=cplex;
option reslim=10800;
option threads=%Nthreads%;

$ifthen.debug not %debug%==on
option limrow=0,limcol=0,solprint=off, sysout=off;
$offlisting
$offsymxref offsymlist
option profile=2;
option profiletol=0.01;
$endif.debug
