# 2048-Point-SDF-Architecture-FFT-Project

This project aims to design a pipelined radix-2 FFT with SDF architecture for 2048 Points.  

Date: 8 July 2019

Participant(s):

Ilayda Yaman https://www.linkedin.com/in/ilayda-yaman-9bba0ab1/ <br/>
Allan Andersen 

**************************************************************************

Brief description of project: 

Description of archive (explain directory structure, documents and source files):

FFT folder includes HDL files

MATLAB_Code folder includes files to verify the results obtained by simulations 

Text_files folder includes the inputs that have been generated, coefficients for 2048-Point-FFT and outputs of the Vivado simulations that have been written into .txt file. 

Instructions to build and test project

Step 1: Go to "Hardware/sources" path for Vivado files of the project

Step 2: Run Simulations

Step 3: Obtain results for the hardware design

Step 4: Compare it with MATLAB results by running the "hardware_outputs_control" file inside the "MATLAB_Code/New" folder 

Note: When regenerating the inputs, to make sure no overflow occurs, the outputs should be generated in range of -0.9 to 0.9. 
