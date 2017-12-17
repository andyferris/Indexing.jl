module Indexing

export getindices, setindices!, dotsetindices!

valtype(a::AbstractDict) = Base.valtype(a)
valtype(a) = Base.eltype(a)

# Possible syntax: container.[indices]
"""
   getindices(container, indices)

Return an indexable container with indices `keys(indices)` and values `container[i]` for
`i ∈ values(indices)`. This generalizes scalar `getindex(container, index)` for multiple
indices, for dictionaries, tuples, etc.

# Examples

```julia

```
"""
function getindices(container, indices)
    # TODO figure out how to do @inbounds
    return map(i -> container[i], indices)
end
getindices(container, ::Colon) = getindices(container, keys(container))

function getindices(container, indices::AbstractDict)
    out = empty(indices, keytype(indices), valtype(container))
    for (i, v) in indices
        out[i] = container[v]
    end
    return out
end

function getindices(a::AbstractArray, is::Int...)
    out = similar(a, eltype(a), ())
    out[] = a[is...]
    return out
end

# Possible syntax: container.[indices] = value
"""
    setindices!(container, value, indices)

Store the given `value` at all the indices `i ∈ values(indices)` of `container`. This
generalizes scalar `setindex!` to dictionaries, etc.
"""
function setindices!(container, value, indices)
    foreach(i -> (container[i] = value), indices)
    return container # Traditionally for setindex! this is value, but that's crazy
end
setindices!(container, value, ::Colon) = setindices!(container, value, keys(container))

function setindices!(container, value, indices::AbstractDict)
    for (i, v) in indices
        container[v] = value
    end
    return container
end


# TODO: 
# 
# * Deal with bounds checking and @inbounds
# * Accelerate for Base containers where necessary
# * Do proper broadcasting with `dotsetindices!`
# * For arrays, `getindices` with scalars (integers) returns a zero-dimensional array

end # module
