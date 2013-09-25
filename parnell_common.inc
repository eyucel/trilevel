Parameters
     ar(v)   agent a reserve factor
         /   0      0
             50     .3
             100    .7 /
     vrcf(v) vacc reserve cost factor
         /   0      0
             50     .5
             100    1 /
     wf(a) warning time factor
         /   A       0.87
             B       0.7
             C       0.8 /
     af(a) agent casualty factor
         /   A       0.9
             B       0.7
             C       0.4 /
     pop(t) target population factor
         /   small   0.001
             medium  0.1
             large   1 /
     pcf(c) potential casualties factor
         /   low     0.6
             nominal 0.8
             high    0.99 /
     Pac(a) prob of acquiring agent
         /   A       0.9
             B       0.5
             C       0.49 / ;

Table Ppc(a,c) prob of potential casualties
         low     nominal     high
A        .3      .4          .3
B        .3      .4          .3
C        .3      .4          .3  ;

Scalars
     bwf biowatch factor /0.9/
     mpop max population /1/
     eif economic impact fixed /10000/
     dtc dollars to casualty /1/
     mbw max bio watch cost /10/
     mcvr max cost for vacc reserve /10/
     mcd max cost to deploy 100% /10/
     mb  max budget  /30/
     cbp cost greater than budget pen. /1/;

Parameters
     x1(w,v,a,t,c,d) US casualties
     wt(a,w) warning time factor
     mc(a,t) max casualties in attack
     pc(a,t,c) potential casualties given attack
     drf(v,d) deploy reserve factor;
* warning time factor
wt(a,w) = 1;
wt(a,"yes") = wf(a)*bwf;
* Max Casualties
mc(a,t) = pop(t) * af(a) * mpop;
* Potential Casualties
pc(a,t,c) = mc(a,t) * pcf(c);
* Deploy reserve factor
drf(v,d) = 1-ar(v);
drf(v,"nodeploy") = 1;
* Casualty Risk
x1(w,v,"A",t,c,d) = pc("A",t,c)* wt("A",w) * drf(v,d);
x1(w,v,"B",t,c,d) = pc("B",t,c) * wt("B",w);
x1(w,v,"C",t,c,d) = pc("C",t,c);

Scalar mei;
* Max Economic impact
mei = eif + dtc*mpop;
Scalar M /1000/;
Scalar w1 casualty weight /1.0/;

Parameters
     x2(w,v,a,t,c,d) US economic effects
     bwc(w) bio watch cost
     vrc(v) vacc reserve cost
     drcf(a,v) deploy reserve cost factor
     cd(a,v,d) depoly vacc cost
     cost(a,w,v,d) US cost to prepare and mitigate attack
     w2 economic weight;
* Economic risk
x2(w,v,a,t,c,d) = eif + x1(w,v,a,t,c,d) * dtc;
* Bio watch Cost
bwc(w) = 0;
bwc("yes") = mbw;
* Vaccine Reserve Cost
vrc(v) = mcvr * vrcf(v);
* Deploy Reserve cost factor
drcf(a,v) = ar(v);
drcf("B",v) = mb + 1;
drcf("C",v) = mb + 1;
drcf(a,"0") = mb + 1;
* Deploy vaccine cost
cd(a,v,d) = 0;
cd(a,v,"deploy") = drcf(a,v) * mcd;
* Total Cost
cost(a,w,v,d) = bwc(w) + vrc(v) + cd(a,v,d);
w2 = 1-w1;

Parameter EV(w,v,a,t,d) expected value;
Parameter risk(w,v,a,t,c,d) total risk;

*total risk
risk(w,v,a,t,c,d) = w1*x1(w,v,a,t,c,d)/mpop + w2*x2(w,v,a,t,c,d)/mei;
* Cost budget penalty
risk(w,v,a,t,c,d)$(cost(a,w,v,d) > mb) = 1;
* Expected value
EV(w,v,a,t,d) = sum((c), risk(w,v,a,t,c,d) * Ppc(a,c))* Pac(a);
