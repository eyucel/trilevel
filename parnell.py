from gams import *
from gdxcc import *
import os
import sys
import numpy as np
import itertools


if __name__ == "__main__":
    cwd = os.getcwd()
    if len(sys.argv) > 1:
        ws = GamsWorkspace(system_directory = sys.argv[1])
    else:
        ws = GamsWorkspace(working_directory=cwd,debug=0)
    sysd = ws.system_directory
    #gdxHandle = new_gdxHandle_tp()
    #rc = gdxCreateD(gdxHandle, sysd, GMS_SSSIZE )
    
#    opt_str = '''SolnPoolAGap = 0.0
#SolnPoolIntensity = 3
#PopulateLim = 20
#SolnPoolPop = 2
#solnpool = "sols.gdx"'''
    #f = open('cplex.opt','w')
    #f.write(opt_str.format(np.random.randint(0,10000)))
    #f.close()
    #opt = ws.add_options()
    #opt.all_model_types = "cplexd"
#    opt.opt_file = 1
    
    
    eps = 10e-4
    w_choices = ("no","yes")
    v_choices = ("0","50","100")
    WV = list(itertools.product(w_choices,v_choices))
    w_hat, v_hat = WV[0]
    XP_set = set()
    z_bar = np.inf
    z_und = -np.inf
    
    iter = 0
    inc_string = '''Set fixW(w) /{0}/;
Set fixV(v) /{1}/;'''
    while abs(z_bar - z_und) > eps:
        if iter > 8:
            break
        print w_hat,v_hat
        f = open('w_hat.inc','w')
        f.write(inc_string.format(w_hat,v_hat))
        f.close()
        t1 = ws.add_job_from_file("parnell3_max_min.gms")
        t1.run()

        for rec in t1.out_db["x"]:
            print rec.keys[2],rec.keys[3],rec.keys[4],rec.level, rec.marginal
            if rec.level > .99:        
                k = rec.keys
                break
        print k
        
        w_hat = k[0]
        v_hat = k[1]    
        a_hat = k[2] #agent deciions
        t_hat = k[3] #target decision
        d_hat = k[4] #deploy decision
        
        XP_set.add((a_hat,t_hat,d_hat))
        z_temp = t1.out_db["r"][0].level 
        if z_temp < z_bar:
            z_bar = z_temp
            w_star = w_hat
            v_star = v_hat
        
        xpi_inc_string = '''Set fixA(a) /{0}/;
    Set fixT(t) /{1}/
    Set fixD(d) /{2}/;'''     
    
        for p in XP_set:
            print p
            a_hat, t_hat, d_hat = p
            f = open('xpi_hat.inc','w')
            f.write(xpi_inc_string.format(a_hat,t_hat,d_hat))
            f.close()
            
            t1 = ws.add_job_from_file("parnell_m_xh_xh.gms")
            t1.run()
            z_temp = t1.out_db["r"][0].level
            if z_temp > z_und:
                z_und = z_temp
            for rec in t1.out_db["x"]:
                
                if rec.level > .99:        
                    k = rec.keys
                    print k
                    break
                w_hat = k[0]
                v_hat = k[1]
        iter += 1
        print z_bar,z_und
        print (z_bar - z_und)