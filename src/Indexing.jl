module Indexing

export getindices, setindices!, dotsetindices!

"""
   getindices(container, indices)

Return an indexable container with indices `keys(indices)` and values `container[i]` for
`i ∈ indices`. This generalizes scalar `getindex(container, index)` for multiple indices,
for dictionaries, tuples, etc.

# Examples

```julia

```
"""
function getindices(container, indices)
    # Possible syntax: container.[indices]

    # TODO figure out how to do @inbounds
    return map(i -> container[i], indices)
end
getindices(container, ::Colon) = getindices(container, keys(container))

function setindices!(container, value, indices)
    # Possible syntax: container.[indices] = value
    foreach(i -> (container[i] = value), indices)
    return container # Traditionally for setindex! this is value, but that's crazy
end
setindices!(container, value, ::Colon) = setindices!(container, value, keys(container))

# Broadcasting version
function dotsetindices!(container, values, indices)
    # Possible syntax: container.[indices] .= values

    # For the moment, expect keys of indices and values to match exactly. In the future,
    # this should support broadcasting semantics.
    foreach(i -> (container[i] = values[i]), indices)
    return container
end
dotsetindices!(container, values, ::Colon) = dotsetindices(container, value, keys(container))

# TODO: 
# 
# * Deal with bounds checking and @inbounds
# * Accelerate for Base containers where necessary
# * Do proper broadcasting with `dotsetindices!`
# * For arrays, `getindices` with scalars (integers) returns a zero-dimensional array
# * Can that be sensibly generalized to dictionaries? Probably not.

end # module
