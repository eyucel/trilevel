Sets
     w biowatch           /yes, no/
     v vaccine storage    /0, 50, 100/
     a agent              /A,B,C/
     t target population  /small, medium, large/
     c potential casualty /low, nominal, high/
     d deploy reserve     /deploy,nodeploy/;

$include "w_hat.inc"
alias(a,agent) ;
alias(t,target) ;
alias(d,deploy);

$include "parnell_common.inc"
*EV(fixW,fixV,a,t,d) = normal(0,0.0001) + EV(fixW,fixV,a,t,d)
Variables
     x(fixW,fixV,a,t,d) strategy
     y(d) defender strategy
     beta defender payoff
     r risk;
binary variable x,y;

Equations
     exprisk  obj function
     joint one joint strategy



     defone one defender strategy
     defjoint(d) defender joint strategies
     defjointrhs(d) defender joint strategies
     defoptlhs(d) defender optimality
     defoptrhs(d) defender optimality;

exprisk..           r =e= sum((fixW,fixV,a,t,d), EV(fixW,fixV,a,t,d) * x(fixW,fixV,a,t,d));
joint..          1 =e= sum((fixW,fixV,a,t,d),   x(fixW,fixV,a,t,d));
defone..         1 =e= sum((d),y(d));
defjoint(d)..  y(d) =l= sum((fixW,fixV,a,t),x(fixW,fixV,a,t,d));
defjointrhs(d).. sum((fixW,fixV,a,t),x(fixW,fixV,a,t,d)) =l= 1;
defoptlhs(d).. 0 =l= (sum((fixW,fixV,a,t), EV(fixW,fixV,a,t,d)*sum((deploy),x(fixW,fixV,a,t,deploy))))-beta;
defoptrhs(d).. (sum((fixW,fixV,a,t), EV(fixW,fixV,a,t,d)*sum((deploy),x(fixW,fixV,a,t,deploy))))-beta =l= (1-y(d)) * M;

Model bioterror /all/;
*bioterror.optfile = 1;
Solve bioterror using MIP maximizing r;
display x.l,x.m;

display EV;