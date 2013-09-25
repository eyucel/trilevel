Sets
     w biowatch           /yes, no/
     v vaccine storage    /0, 50, 100/
     a agent              /A,B,C/
     t target population  /small, medium, large/
     c potential casualty /low, nominal, high/
     d deploy reserve     /deploy,nodeploy/;

$include "xpi_hat.inc"
alias(fixA,agent) ;
alias(fixT,target) ;
alias(fixD,deploy);
$include "parnell_common.inc"

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
Sets soln           possible solutions in the solution pool /file1*file1000/
     solnpool(soln) actual solutions;
Scalar cardsoln     number of solutions in the pool;
Alias (soln,s1,s2), (*,u);
Parameters
    owX(soln,w,v,fixA,fixT,fixD)    warehouse indicator by solution
    xcostX(soln,*) cost structure by solution;
files fsoln, fcpx / cplex.opt /;
option limrow=0, limcol=0, optcr=0, mip=cplex;
bioterror.optfile=1; bioterror.solprint=%solprint.Quiet%; bioterror.savepoint = 1;

* The code to load different solution from gdx files will be used
* several times in this program and we therefore copy it into an include file.
$onecho > readsoln.gms
execute_load 'solnpool.gdx', solnpool=index;
cardsoln = card(solnpool); display cardsoln;
owX(soln,w,v,fixA,fixT,fixD) = 0; xcostX(soln,u) = 0;
loop(solnpool(soln),
  put_utility fsoln 'gdxin' / solnpool.te(soln);
  execute_loadpoint;
  owX(soln,w,v,fixA,fixT,fixD)               = round(x.l(w,v,fixA,fixT,fixD));
  xcostX(soln,'totcost')    = r.l;
  xcostX(soln,'tcost')      = r.l;
);
* Restore the solution reported to GAMS
execute_loadpoint 'bioterror_p.gdx';
$offecho



putclose fcpx 'solnpool solnpool.gdx' /'solnpoolagap = 0' / 'solnpoolintensity 4' / 'solnpoolpop 2';
solve bioterror min r using mip;
$include readsoln
display xcostX;
display owX;
*Solve bioterror using MIP minimizing r;

