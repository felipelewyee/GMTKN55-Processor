using CSV
using DataFrames
using YAML

benchmark = readline()

f = open(benchmark * ".ref")
data = Dict()    
for line in readlines(f)
    set = split(line)[1]
    reactions = split(line)[2:end]

    println("===============================")
    println(set)

    df = CSV.read(set * ".csv", DataFrame)
    df = df[!, 2:end] #Remove index column
    nmols = Int((size(df)[2] - 1)/2) #Number of mols

    for reaction in reactions
        state = 0
	row = df[parse(Int64,reaction), 1:end]

        local_data = []
	mols = []
	for element in row[1:nmols]
	    if !ismissing(element)
                push!(mols, string(element))
            end
	end
	coeffs = []
	for element in row[nmols+1:2*nmols]
	    if !ismissing(element)
                push!(coeffs, string(element))
            end
	end
	dE = row[end]
	push!(local_data, dE)
	for (coeff, mol) in zip(coeffs, mols)
            push!(local_data, "[" * string(coeff) * ", " * mol * ".xyz" * "]")
	end
	data[set * ":" * reaction] = local_data
    end
end

open(benchmark * ".yaml", "w") do io
        YAML.write(io, data)
end
