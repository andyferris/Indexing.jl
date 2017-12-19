module Indexing

import Base: getindex, setindex!, view, IndexStyle, @propagate_inbounds, axes, keys, haskey,
             parent, length, start, done, next

export getindices, setindices!, ViewArray, ViewVector, ViewMatrix, ViewDict

_valtype(a::AbstractDict) = Base.valtype(a)
_valtype(a) = Base.eltype(a)

include("getindices.jl")
include("setindices.jl")
include("view.jl")

# TODO: 
# 
# * Deal better with bounds checking and @inbounds
# * Accelerate for Base containers where necessary?

end # module
