execute_load 'solnpool.gdx', solnpool=index;
cardsoln = card(solnpool); display cardsoln;
owX(soln,p1,fixP2,fixMIT) = 0; xcostX(soln,u) = 0;
loop(solnpool(soln),
  put_utility fsoln 'gdxin' / solnpool.te(soln);
  execute_loadpoint;
  owX(soln,p1,fixP2,fixMIT)               = round(x.l(p1,fixP2,fixMIT));
  xcostX(soln,'totcost')    = r.l;
  xcostX(soln,'tcost')      = r.l;
);
* Restore the solution reported to GAMS
execute_loadpoint 'little_p.gdx';
