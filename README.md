# GMTKN55-Processor

This scripts aims to get the files of GMTKN55 and extract the information for other subsets.

A file *benchmark.ref* with the following format is expected
```
AHB21 1 2 4
W4-11 1 3 5
BH76 4 30 42
```
Then, execute the following scripts in Julia

- **data.jl**: Download the data of GMTKN55. Produces: **.tar* (geometries), **.csv* (reaction data) and **.txt* (charge and multiplicity) for each set
- **processing.jl**: Generate the summay file with the reaction:set-energy-stoichometry-molecules. Produces: *benchmark.yaml*
- **xyz.jl**: Take the necesary xyz, add charge and multiplicity, verify capitalization of atoms, and create files: *SET-molecule.xyz*

## Recommended workflow

Replace *benchmark* with the corresponding name (e.g. Slim05) and execute the following lines 

```bash
julia data.jl
julia processing.jl

# To remove unnecesary double quotation mark 
sed -i -e "s/\"//g" *.yaml
sed -i -e "s/, /, \"/g" *.yaml
sed -i -e "s/xyz/xyz\"/g" *.yaml

for file in *.tar; do echo $file; tar -xvf $file; done
cp -r BH76 BH76RC

julia xyz.jl
mkdir benchmark
mv *.xyz benchmark
```
