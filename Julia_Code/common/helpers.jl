using JSON
import Base.length
include(joinpath("$JULDIR","GAFunctions","structures.jl"))

function load_config_json(path_to_config_file::String)
    return JSON.parsefile(path_to_config_file)
end

length(x::phenotype) = 1

