# Indexing

*Generalized indexing for Julia*

[![Build Status](https://github.com/andyferris/Indexing.jl/workflows/CI/badge.svg)](https://github.com/andyferris/Indexing.jl/actions?query=workflow%3ACI)
[![codecov.io](http://codecov.io/github/andyferris/Indexing.jl/coverage.svg?branch=master)](http://codecov.io/github/andyferris/Indexing.jl?branch=master)

-----------

This package defines functions for getting multiple indices out of dictionaries, tuples,
etc, extending this ability beyond `AbstractArray`.

To acheive this, we introduce new functions and methods:

 * `getindices(container, indices)` - generalizes `getindex(container, index)` to multiple indices.
 * `setindices!(container, value, indices)` - generalizes `setindex!(container, value, index)` to multiple indices. The same `value` is set for
   each index in `indices`.
 * `view(container, indices)` - lazy versions of `getindices(container, indices)` defined for dictionaries.
 
## Quick start

You can install Indexing via Julia's package manager:

```
julia> using Pkg

julia> Pkg.add("Indexing")

julia> using Indexing

julia> d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
Dict{Symbol,String} with 3 entries:
  :a => "Alice"
  :b => "Bob"
  :c => "Charlie"

julia> getindices(d, [:a, :c]) # Preserves type/keys of index collection - an array of length 2
2-element Array{String,1}:
 "Alice"  
 "Charlie"

julia> getindices(d, (:a, :c)) # Preserves type/keys of index collection - a tuple of length 2
("Alice", "Charlie")

julia> getindices(d, Dict("Wife" => :a, "Husband" => :c)) # Preserves type/keys of index collection - a dictionary with keys "Wife" and "Husband"
Dict{String,String} with 2 entries:
  "Wife"    => "Alice"
  "Husband" => "Charlie"
```

Similarly, `view` works as a lazy version of `getindices`, and `setindices!` works by
setting *the same* value to each specified index.

## TODO

This package is a work-in-progress. To complete the package, we need to:

  * Performance improvements and propagation of `@inbounds` annotations.

## Future thoughts

Perhaps these could be intergrated into future Julia syntax. One suggestion:

```julia
a[i]               --> getindex(a, i)       # scalar only
a.[inds]           --> getindices(a, inds)
a[i] = v           --> setindex!(a, v, i)   # scalar only
a.[inds] = v       --> setindices!(a, v, inds)
a[i] .= v          --> broadcast!(identity, a[i], v)
a.[inds] .= values --> broadcast!(identity, view(a, inds), values)
```
Note the lack of `dotview` and `maybeview`. The last two could support dot-fusion on the RHS.
Also, the default for `a.[inds]` could potentially move to `view`.
