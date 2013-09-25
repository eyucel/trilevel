Sets
     w biowatch           /yes, no/
     v vaccine storage    /0, 50, 100/
     a agent              /A,B,C/
     t target population  /small, medium, large/
     c potential casualty /low, nominal, high/
     d deploy reserve     /deploy,nodeploy/;

$include "m1_hat.inc"
$include "m2_hat.inc"

$include "parnell_common.inc"

Variables
     x(fixW,fixV,a,t,fixD) strategy
     r risk;
Binary variable x;
Equations
     exprisk  obj function
     joint one joint strategy;

exprisk..           r =e= sum((fixW,fixV,a,t,fixD), EV(fixW,fixV,a,t,fixD) * x(fixW,fixV,a,t,fixD));
joint..          1 =e= sum((fixW,fixV,a,t,fixD),   x(fixW,fixV,a,t,fixD));


Model bioterror /all/;
*bioterror.optfile = 1;
Solve bioterror using MIP maximizing r;
display EV
display x.l, x.m
display r.l   