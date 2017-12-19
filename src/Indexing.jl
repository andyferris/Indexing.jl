module Indexing

export getindices, setindices!, dotsetindices!

valtype(a::AbstractDict) = Base.valtype(a)
valtype(a) = Base.eltype(a)

include("getindices.jl")
include("setindices.jl")
include("view.jl")

# TODO: 
# 
# * Views of dictionaries, etc
# * Deal with bounds checking and @inbounds
# * Accelerate for Base containers where necessary

end # module
