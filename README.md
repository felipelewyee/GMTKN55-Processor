# GMTKN55-Processor

This scripts aims to get the files of GMTKN55 and extract the information for other subsets.

A file *benchmark.txt* with the following format is expected
'''
AHB21 1 2 4
W4-11 1 3 5
BH76 4 30 42
'''

data.jl: Download the data from the web of GMTKN55. Produces *.tar (geometries), *.csv (reaction data) and *.txt (charge and multiplicity) for each set
processing.jl: Generate the summay file with the reaction:set-energy-stoichometry-molecules. Produces *benchmark.yaml*
xyz.jl: Take the necesary xyz, add charge - multiplicity and put it in folder
