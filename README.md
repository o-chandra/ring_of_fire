This is a repository to hold the code associated with the paper "The impact of a wind switch on the stability of traveling fronts in a reaction-diffusion model of fire propagation" by Olivia Chandrasekhar, Chris Jones, Blake Barker and Rod Linn. The pre-print is available on the ArXiv. 

The "matlab_code" folder contains Matlab code for calculating profile solutions. To generate data for profile solutions and associated parameters, run "driver_save_profiles.m" in the "drivers" folder. This will populate (or re-populate) the "profile_data" folder.

To run the accumulated angle code for stability calculations, either run "driver_accumulated_angle.m" or use the code in the "python_code" folder, in which case you will need to copy the data you generated using the matlab code in to "python_code/data."
Currently, the data needs to be manually re-labeled so that, eg, "id1_info.csv" becomes "id01_info.csv" and manually sorted so that info data and profile data are in the correct folders. In the future this will be automated.

In the python_code folder, there are two Jupyter notebooks to calculate solution trajectories and intersections for intersections of type 1 and 2, as defined in the paper. There is also a Jupyter notebook to calculate the accumulated angle, angular solution trajectories and eigenvalue minimizer for solutions corresponding to type 1 intersections.

The accumulated angle code requires several helper .py functions, included in the "python_profile_code" folder. 


