# Possible syntax: container.[indices]
"""
getindices(container, indices)

Return an indexable container with indices `keys(indices)` and values `container[i]` for
`i ∈ values(indices)`. This generalizes scalar `getindex(container, index)` for multiple
indices, for dictionaries, tuples, named tuples, etc.

# Examples

```julia
julia> d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
Dict{Symbol,String} with 3 entries:
  :a => "Alice"
  :b => "Bob"
  :c => "Charlie"

julia> getindices(d, [:a, :c])
2-element Array{String,1}:
 "Alice"  
 "Charlie"

julia> getindices(d, (:a, :c))
("Alice", "Charlie")

julia> getindices(d, Dict("Wife" => :a, "Husband" => :c))
Dict{String,String} with 2 entries:
  "Wife"    => "Alice"
  "Husband" => "Charlie"
```
"""
function getindices(container, indices)
    # TODO figure out how to do @inbounds
    return map(i -> container[i], indices)
end
getindices(container, ::Colon) = getindices(container, keys(container))
getindices(t::Tuple, ::Colon) = t
getindices(nt::NamedTuple, ::Colon) = nt

function getindices(container, indices::AbstractDict)
    out = empty(indices, keytype(indices), _valtype(container))
    for (i, v) in indices
        out[i] = container[v]
    end
    return out
end
function getindices(d::AbstractDict, ::Colon)
    return copy(d)
end

# Make a 0-D array instead of scalar
Base.@propagate_inbounds function getindices(a::AbstractArray, is::Int...)
    out = similar(a, eltype(a), ())
    out[] = a[is...]
    return out
end

# Ambiguities
Base.@propagate_inbounds getindices(a::AbstractArray, is::Union{Int,Colon,AbstractArray}...) = a[is...]
getindices(a::AbstractVector, ::Colon) = a[:]