"""Automate TurbsimFile generation - Kumara Raja E, with help from Abhinav M
"""
# This code automatically generates the wind input files for Turbsim for different mean and random seed values
# Run this code from the directory where the "Template_Wind_NTM_xx_mps.template" is placed.

from mako.template import Template

# This function generates the "ElastoDyn" and "Inflow wind" input files required for
# OpenFAST simulation from the template files (by changing the parameter values accordingly).
def create_data_files(fileName, mean_wind_speed, rand_seed_num):
    with open('TemplateV20_Wind_NTM_xx_mps.template', 'r') as f:    # Open file Template_Wind_NTM_xx_mps.template in read mode
        data = f.read() # 
        ftmp = Template(data).render(
            U_Ref = mean_wind_speed,
            RandSeed_1 = rand_seed_num
        )
    
    wind_fname = fileName
    with open(wind_fname, 'w') as f:
        f.write(ftmp)
        f.close()

# This is the code that is used to run. It calls above functions.
if __name__ == '__main__':
    import numpy as np
    import os
    mean_wind_speeds = np.arange(11,21,1)
    rand_seeds_dict = {'seed01':1474,'seed02':28647,'seed03':148364,'seed04':1748647,'seed05':24452378,'seed06':10537899}
    cnt = 1
    for mean_wind_speed in mean_wind_speeds:
        for key in rand_seeds_dict:
            rand_seed_num = rand_seeds_dict[key]
            fileName = "Wind_NTM_"+str(mean_wind_speed).zfill(2)+"mps_"+key+".inp"
            create_data_files(fileName, mean_wind_speed, rand_seed_num)
