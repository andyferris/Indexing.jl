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
