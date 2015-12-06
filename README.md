!REQUIREMENTS

* MATLAB >=6.5 for .m files
* PYTHON 2.7, NUMPY, SCIPY y MATPLOTLIB  for .py file
* It can take several seconds so be patient.

!TEST

main_mapping.py -i intel.gfs.log -o map_intel_lab -d 0.5 -r -15,20,-25,10

!FILES
main_sampling.m		Sampling    motion model
main_closed.m 	    Closed form motion model
main_trayectory.m   Show the uncertainty growth in robot pose along the trayectory.
main_mapping.py     Computes reflection map
