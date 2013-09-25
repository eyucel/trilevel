Sets
     w biowatch           /yes, no/
     v vaccine storage    /0, 50, 100/
     a agent              /A,B,C/
     t target population  /small, medium, large/
     c potential casualty /low, nominal, high/
     d deploy reserve     /deploy,nodeploy/;

$include "m2_hat.inc"
$include "x_hat.inc"
alias(fixA,agent);
alias(fixT,target) ;
alias(fixD,deploy);

$include "parnell_common.inc"
*EV(w,v,fixA,fixT,fixD) = normal(0,0.0001) + EV(w,v,fixA,fixT,fixD) 
Variables
     x(w,v,fixA,fixT,fixD) strategy
     r risk;
Binary variable x,y;
Equations
     exprisk  obj function
     joint one joint strategy;

exprisk..           r =e= sum((w,v,fixA,fixT,fixD), EV(w,v,fixA,fixT,fixD) * x(w,v,fixA,fixT,fixD));
joint..          1 =e= sum((w,v,fixA,fixT,fixD),   x(w,v,fixA,fixT,fixD));


Model bioterror /all/;
*bioterror.optfile = 1;
Solve bioterror using MIP minimizing r;
display EV
display x.l, x.m
display r.l   