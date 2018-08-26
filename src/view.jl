## Array views of other indexable containers
"""
    ViewArray(parent, indices)

Create an array `out` which is a lazy view of `parent`. The indices of `out` match the
indices of `indices`, and the values of `indices` are used to index `parent`. Unlike
`SubArray`, the parent type could be any indexable container (for instance, we can create an
`AbstractArray` view of the values stored in an `AbstractDict`).

See also `ViewDict`, `view`.

# Examples

```julia
julia> d = Dict(:a => 11, :b => 12, :c => 13)
Dict{Symbol,Int64} with 3 entries:
  :a => 11
  :b => 12
  :c => 13

julia> ViewArray(d, [:a, :c])
2-element ViewArray{Int64,1,Dict{Symbol,Int64},Array{Symbol,1}}:
 11
 13
```
"""
struct ViewArray{T, N, A, I <: AbstractArray{<:Any, N}} <: AbstractArray{T, N}
    parent::A
    indices::I
end

ViewArray(a, indices::AbstractArray) = ViewArray{_valtype(a)}(a, indices)
ViewArray{T}(a, indices::AbstractArray) where {T} = ViewArray{T, ndims(indices)}(a, indices)
ViewArray{T, N}(a, indices::AbstractArray) where {T, N} = ViewArray{T, N, typeof(a)}(a, indices)
ViewArray{T, N, A}(a, indices::AbstractArray) where {T, N, A} = ViewArray{T, N, A, typeof(indices)}(a, indices)

# vector & matrix versions
const ViewVector{T, A, I <: AbstractVector} = ViewArray{T, 1, A, I}
ViewVector(a, indices::AbstractVector) = ViewVector{_valtype(a)}(a, indices)

const ViewMatrix{T, A, I <: AbstractMatrix} = ViewArray{T, 2, A, I}
ViewMatrix(a, indices::AbstractMatrix) = ViewMatrix{_valtype(a)}(a, indices)

# `AbstractArray` implementation (no resizing)
IndexStyle(::Type{ViewArray{T, N, A, I}}) where {T, N, A, I} = IndexStyle(I)
axes(a::ViewArray) = axes(a.indices)
size(a::ViewArray) = size(a.indices)

@propagate_inbounds getindex(a::ViewArray, i::Int) = a.parent[a.indices[i]]
@propagate_inbounds getindex(a::ViewArray, is::Int...) = a.parent[a.indices[is...]]

@propagate_inbounds setindex!(a::ViewArray, v, i::Int) = (a.parent[a.indices[i]] = v)
@propagate_inbounds setindex!(a::ViewArray, v, is::Int...) = (a.parent[a.indices[is...]] = v)

# Connect with `view`
"""
    view(d::AbstractDict, inds::AbstractArray)

Create an array view over the dictionary `d` with the indices stored in `inds`.

See also `ViewArray`.

# Examples

```julia
julia> d = Dict(:a => 11, :b => 12, :c => 13)
Dict{Symbol,Int64} with 3 entries:
  :a => 11
  :b => 12
  :c => 13

julia> view(d, [:a, :c])
2-element ViewArray{Int64,1,Dict{Symbol,Int64},Array{Symbol,1}}:
 11
 13
```
"""
view(d::AbstractDict, inds::AbstractArray) = ViewArray{_valtype(d), ndims(inds)}(d, inds)
parent(a::ViewArray) = a.parent


## Dictionary views of indexable containers
"""
    ViewDict(parent, indices)

Create an array `out` which is a lazy view of `parent`. The indices of `out` match the
indices of `indices`, and the values of `indices` are used to index `parent`. The parent
must be an indexable type - for instance, an array or dictionary.

See also `ViewArray`, `view`.

# Examples

```julia
julia> d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
Dict{Symbol,String} with 3 entries:
  :a => "Alice"
  :b => "Bob"
  :c => "Charlie"

julia> ViewDict(d, Dict(:aa => :a, :cc => :c))
ViewDict{Symbol,String,Dict{Symbol,String},Dict{Symbol,Symbol}} with 2 entries:
  :aa => "Alice"
  :cc => "Charlie"

julia> v = [11, 12, 13]
3-element Array{Int64,1}:
 11
 12
 13

julia> ViewDict(v, Dict(:a =>1 , :c => 3))
ViewDict{Symbol,Int64,Array{Int64,1},Dict{Symbol,Int64}} with 2 entries:
  :a => 11
  :c => 13
```
"""
struct ViewDict{K, V, A, I} <: AbstractDict{K, V}
    parent::A
    indices::I
end

ViewDict(a, indices) = ViewDict{keytype(indices)}(a, indices)
ViewDict{K}(a, indices) where {K} = ViewDict{K, _valtype(a)}(a, indices)
ViewDict{K, V}(a, indices) where {K, V} = ViewDict{K, V, typeof(a)}(a, indices)
ViewDict{K, V, A}(a, indices) where {K, V, A} = ViewDict{K, V, A, typeof(indices)}(a, indices)

# `AbstractDict` implementation (immutable keys)
keys(d::ViewDict) = keys(d.indices)
haskey(d::ViewDict, i) = haskey(d.indices, i)
length(d::ViewDict) = length(d.indices)

@propagate_inbounds getindex(d::ViewDict, i) = d.parent[d.indices[i]]
@propagate_inbounds setindex!(d::ViewDict, v, i) = (d.parent[d.indices[i]] = v)

function iterate(d::ViewDict, state...)
    tmp = iterate(d.indices, state...)
    if tmp === nothing
        return tmp
    end
    (kv, state2) = tmp
    return (kv.first => d.parent[kv.second], state2)
end

# Connect with `view`
"""
    view(parent, inds::AbstractDict)

Create a dictionary view over the indexable container `parent`. The indices of the output
are the indices of `inds`, and the values are the corresponding `parent[i]` for 
`i in values(inds)`.

See also `ViewDict`.

# Examples

```julia
julia> d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
Dict{Symbol,String} with 3 entries:
  :a => "Alice"
  :b => "Bob"
  :c => "Charlie"

julia> view(d, Dict(:aa => :a, :cc => :c))
ViewDict{Symbol,String,Dict{Symbol,String},Dict{Symbol,Symbol}} with 2 entries:
  :aa => "Alice"
  :cc => "Charlie"

julia> v = [11, 12, 13]
3-element Array{Int64,1}:
 11
 12
 13

julia> view(v, Dict(:a =>1 , :c => 3))
ViewDict{Symbol,Int64,Array{Int64,1},Dict{Symbol,Int64}} with 2 entries:
  :a => 11
  :c => 13
```
"""
view(d, inds::AbstractDict) = ViewDict(d, inds)
view(d::AbstractArray, inds::AbstractDict) = ViewDict(d, inds) # disambiguation
parent(d::ViewDict) = d.parent
