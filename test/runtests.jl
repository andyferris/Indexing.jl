using Indexing
using Test

@testset "getindices" begin
   d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
   @test getindices(d, [:a, :c]) == ["Alice", "Charlie"]
   @test getindices(d, (:a, :c)) == ("Alice", "Charlie")
   @test getindices(d, Dict(:a => :a, :c => :c)) == Dict(:a => "Alice", :c => "Charlie")

   v = [11, 12, 13]
   @test (getindices(v, 2)::Array{Int, 0})[] == 12
   @test getindices(v, [1, 3]) == [11, 13]
   @test getindices(v, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
   @test getindices(v, (1, 3)) == (11, 13)

   v = (11, 12, 13)
   @test getindices(v, [1, 3]) == [11, 13]
   @test getindices(v, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
   @test getindices(v, (1, 3)) == (11, 13)
end

@testset "setindices!" begin
    d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
    d2 = copy(d)
    setindices!(d2, "Someone", [:a, :c])
    @test d2 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")

    d3 = copy(d)
    setindices!(d3, "Someone", (:a, :c))
    @test d3 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")

    d4 = copy(d)
    setindices!(d4, "Someone", Dict(:a => :a, :c => :c))
    @test d4 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")

    v = [11, 12, 13]
    v2 = copy(v)
    setindices!(v2, 20, [1, 3])
    @test v2 == [20, 12, 20]

    v3 = copy(v)
    setindices!(v3, 20, (1, 3))
    @test v3 == [20, 12, 20]

    v4 = copy(v)
    setindices!(v4, 20, Dict(:a => 1, :c => 3))
    @test v4 == [20, 12, 20]
     
end