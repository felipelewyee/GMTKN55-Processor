using CSV
using DataFrames
using YAML

println("Enter name of *.ref file (e.g. benchmark.ref, P30-5.ref, Slim05.ref, Diet030.ref:")
benchmark = readline()

# Read yaml and look for unique sets
data = YAML.load_file(benchmark * ".yaml")
sets = []
for (reaction, reaction_data) in data
    set_name, reaction_id = split(reaction, ":")
    push!(sets, set_name)
end
sets = Set(sets)
println(sets)

# Read databases of charge and multiplicity for each set
char_mult = Dict()
for set_name in sets
    header = [:molname, :charge, :mult]
    df = CSV.read(set_name * ".txt", DataFrame; delim=' ', ignorerepeated=true, header=header, types=[String, Int32, Int32])
    char_mult[set_name] = df
end

# Generate a list of unique systems
mols_in_sets = Dict()
for set_name in sets
    mols_in_sets[set_name] = String[]
end
# look the yaml for molecules
data = YAML.load_file(benchmark * ".yaml")
for (reaction, reaction_data) in data
    set_name, reaction_id = split(reaction, ":")
    molecules = reaction_data[2:end]
    for (coeff, xyzfile) in molecules
	push!(mols_in_sets[set_name], xyzfile[1:end-4])
    end
end
# turn the list of molecules into sets
for set_name in sets
    mols_in_sets[set_name] = Set(mols_in_sets[set_name])
end

# Generate the xyz files
data = YAML.load_file(benchmark * ".yaml")
for set_name in sets
    mols = mols_in_sets[set_name]
    cms = char_mult[set_name]
    for mol in mols
        row = cms[cms.molname .== mol, :]
        charge = row.charge[1]
	mult = row.mult[1]

        println(mol)
        xyz = ""
        for (i, line) in enumerate(eachline(set_name*"/"*mol*"/"*"struc.xyz"))
	    if (i==1)
                xyz = xyz * string(parse(Int32,line)) * "\n"
	    elseif (i==2)
                xyz = xyz * string(charge) * " " * string(mult) * "\n"
            elseif (i>=2)
                atom, x, y, z = split(line)
		if length(atom) > 1
		    formatted_line = replace(line, atom => uppercasefirst(lowercase(atom)))
		    xyz = xyz * formatted_line * "\n"
		else
		    xyz = xyz * line * "\n"
		end
            end
        end
        open(set_name * "-" * mol*".xyz", "w") do fmol
            print(fmol, xyz)
        end
    end
end
