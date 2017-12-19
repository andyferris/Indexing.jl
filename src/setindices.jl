
# Possible syntax: container.[indices] = value
"""
setindices!(container, value, indices)

Store the given `value` at all the indices in `values(indices)` of `container`. This
generalizes scalar `setindex!` for dictionaries, etc.
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
