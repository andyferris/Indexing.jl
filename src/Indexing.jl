module Indexing

import Base: getindex, setindex!, view, IndexStyle, @propagate_inbounds, keys, haskey,
             parent, length, start, done, next

export getindices, setindices!, ViewArray, ViewVector, ViewMatrix, ViewDict

if VERSION < v"0.7-"
    # Could use Compat, but this way I can keep track of what's changing
    const AbstractDict = Associative
    import Base.indices
    const axes = indices
    empty(d::Associative, ::Type{K}, ::Type{V}) where {K, V} = similar(d, Pair{K,V})
else
    import Base.axes
end

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
