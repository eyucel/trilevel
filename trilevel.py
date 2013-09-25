# -*- coding: utf-8 -*-
"""
Created on Wed Jul 24 13:02:40 2013

@author: Emre
"""

from gams import *
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

    
    print cwd
    eps = 10e-4
    w_choices = ("no","yes")
    v_choices = ("0","50","100")
    WV = itertools.product(w_choices,v_choices)
    
    XP_set = set()
    visited_sols = set()
    z_bar = np.inf
    z_und = -np.inf
    iter = 0
    inc_string = '''Set fixW(w) /{0}/;
Set fixV(v) /{1}/;'''
    for combo in WV:

        
        w_hat,v_hat = combo
        f = open('w_hat.inc','w')
        f.write(inc_string.format(w_hat,v_hat))
        f.close()
        t1 = ws.add_job_from_file("parnell3_max_min.gms")
        t1.run()
        z_temp = t1.out_db["r"][0].level 
        for rec in t1.out_db["x"]:
            if rec.level > .99: 
                
                if z_temp < z_bar:       
                    k = rec.keys
                    w_star = k[0]
                    v_star = k[1]    
                    a_star = k[2] #agent deciions
                    t_star = k[3] #target decision
                    d_star = k[4] #deploy decision
                    val_star = z_temp
        
    
    print val_star, k            
        