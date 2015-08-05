This folder contains three MATLAB scripts used for the simulations in "Optimizing the mass-specific activity of bilirubin oxidase adlayers through combined electrochemical quartz crystal microbalance and dual polarization interferometry analyses" by McArdle and co-workers. They are called from the command window. Function descriptions and definitions appear as comments in the head of each function.

The sub-folder "Variables" contains structures with preset values for constants and options that are required to use the functions.
The sub-folder "Internal functions" folder are called by the main scripts and do not need to be accessed directly.

TO USE:
1. Copy the three functions and sub-folders to the MATLAB folder and add all to the MATLAB's path.
2. Load the appropriate structures from the "Variables" folder by double-clicking on them:
   - "adlayer_change.m" requires "controls_adlayer.mat" and "graphs_adlayer.mat"
   - "full_QCMD.m" requires "controls_QCMD.mat", "graphs_QCMD.mat" and "inputs_QCMD.mat"
   - "DF_predictor.m" requires "controls_DvsF.mat" and "graphs_DvsF.mat"
3. Execute the function by entering the text in quotation marks and hitting enter:
   - adlayer_change -> "[output]=adlayer_change(controls,graphs)"
   - DF_predictor ---> "DF_predictor(controls,graphs)"
   - full_QCMD ------> "[output]=full_QCMD(inputs,controls,graphs)"
4. "Busy" will appear in the bottom left then graphs will appear and the data will be stored in the structure "output".

~~~ T.P. McNamara and Christopher Blanford <christopher.blanford@manchester.ac.uk> 2015-08-04