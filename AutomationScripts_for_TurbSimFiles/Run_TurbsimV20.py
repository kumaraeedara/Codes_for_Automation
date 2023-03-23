# Author: Kumara Raja E;

#from re import T
import subprocess
import glob

def run_turbsim(turbsim_inp_file):
    # This command runs in Parallel
    #subprocess.Popen('cmd /K TurbSim_x64.exe ' + turbsim_inp_file,shell=True)

    # This comman runs in Serial
    subprocess.run('cmd /K TurbSim_x64.exe ' +turbsim_inp_file, shell=True, capture_output=True)


if __name__ == '__main__':
    turbsim_input_files = glob.glob('*.inp')
    print(len(turbsim_input_files))
    for file in turbsim_input_files:
        print(file)
        run_turbsim(file)
