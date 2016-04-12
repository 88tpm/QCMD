This folder contains three MATLAB scripts used for the simulations in "A Sensitivity Metric and Software to Guide the Analysis of Soft Films 
Measured by a Quartz Crystal Microbalance" by McNamara and Blanford. They are called from the command window. Function descriptions and definitions appear as comments in the head of each function.

The sub-folder "Controls" contains structures with preset values for constants and options that are required to use the functions.
The sub-folder "Core functions" folder are called by the main scripts and do not need to be accessed directly.

TO USE:
1. Copy the three functions and sub-folders to the MATLAB folder and add all to the MATLAB's path.
2. Load the appropriate structures from the "Controls" folder by double-clicking on them:
   - "combo.m" requires "controls_combo.mat"
   - "TPM_sensitivity.m" requires "controls_TPM.mat"
   - "voigt_responses.m" requires "controls_voigt.mat"
3. Execute the function by entering the text in quotation marks and hitting enter:
   - combo -> "[combinations,score,fd_derivative] = combo(controls)"
   - TPM_sensitivity ---> "[output] = TPM_sensitivity(controls,properties,fixed_properties)"
   - voigt_responses ---> "[output]=voigt_responses(controls)"
4. "Busy" will appear in the bottom left then graphs will appear and the data will be stored in the structure "output".

~~~ T.P. McNamara and Christopher Blanford <christopher.blanford@manchester.ac.uk> 2016-01-13