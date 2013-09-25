Sets
     w biowatch           /yes, no/
     v vaccine storage    /0, 50, 100/
     a agent              /A,B,C/
     t target population  /small, medium, large/
     c potential casualty /low, nominal, high/
     d deploy reserve     /deploy,nodeploy/;

$include "m1_hat.inc"
$include "x_hat.inc"

$include "parnell_common.inc"

Variables
     x(fixW,fixV,fixA,fixT,d) strategy
     r risk;
Binary variable x;
Equations
     exprisk  obj function
     joint one joint strategy;

exprisk..           r =e= sum((fixW,fixV,fixA,fixT,d), EV(fixW,fixV,fixA,fixT,d) * x(fixW,fixV,fixA,fixT,d));
joint..          1 =e= sum((fixW,fixV,fixA,fixT,d),   x(fixW,fixV,fixA,fixT,d));


Model bioterror /all/;
*bioterror.optfile = 1;
Solve bioterror using MIP minimizing r;
display EV
display x.l, x.m
display r.l   