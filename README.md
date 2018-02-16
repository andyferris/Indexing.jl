# Indexing

*Generalized indexing for Julia*

[![Build Status](https://travis-ci.org/andyferris/Indexing.jl.svg?branch=master)](https://travis-ci.org/andyferris/Indexing.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/1vm5k6cy4jitfns7?svg=true)](https://ci.appveyor.com/project/andyferris/indexing-jl)
[![Coverage Status](https://coveralls.io/repos/andyferris/Indexing.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/andyferris/Indexing.jl?branch=master)
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

Please note that this package is still under development. However, you can check it out with
Julia v0.6 or greater, and use it like so:

```
julia> Pkg.clone("https://github.com/andyferris/Indexing.jl")

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
