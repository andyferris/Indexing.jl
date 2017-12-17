# Indexing

*Generized indexing for Julia*

[![Build Status](https://travis-ci.org/andyferris/Indexing.jl.svg?branch=master)](https://travis-ci.org/andyferris/Indexing.jl)
[![Coverage Status](https://coveralls.io/repos/andyferris/Indexing.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/andyferris/Indexing.jl?branch=master)
[![codecov.io](http://codecov.io/github/andyferris/Indexing.jl/coverage.svg?branch=master)](http://codecov.io/github/andyferris/Indexing.jl?branch=master)

-----------

This package defines functions for getting multiple indices out of dictionaries, tuples,
etc, extending this ability beyond `AbstractArray`.

To acheive this, we introduce new functions:

 * `getindices` - generalizes `getindex` to multiple indices.
 * `setindices!` - generalizes `setindex!` to multiple indices. The same value is set for
   each index.
 
## Quick start

Please note that this package is still under development and is not fully functional. 
However, you can check it out with Julia v0.6 or greater, and use it like so:

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

## TODO

This package is a work-in-progress. To complete the package, we need to at least:

  * Make sure everything works for named tuples.
  * Make `view` work for dictionaries.
  * Performance improvements and propagation of `@inbounds` annotations.


## Future thoughts

Perhaps these could be intergrated into future Julia syntax. One simple suggestion:

```julia
a.[inds]           --> getindices(a, inds)
a.[inds] = v       --> setindices!(a, v, inds)
a[i] .= v          --> broadcast!(identity, a[i], v)
a.[inds] .= values --> broadcast over inds and values (like the current `dotview`, for above, but works on dictionaries)
```
