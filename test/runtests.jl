using Indexing
using Test

@testset "getindices" begin
   d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
   @test getindices(d, [:a, :c]) == ["Alice", "Charlie"]
   @test getindices(d, (:a, :c)) == ("Alice", "Charlie")
   @test getindices(d, Dict(:aa => :a, :cc => :c)) == Dict(:aa => "Alice", :cc => "Charlie")
   @test getindices(d, (aa = :a, cc = :c)) == (aa = "Alice", cc = "Charlie")

   v = [11, 12, 13]
   @test (getindices(v, 2)::Array{Int, 0})[] == 12
   @test getindices(v, [1, 3]) == [11, 13]
   @test getindices(v, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
   @test getindices(v, (1, 3)) === (11, 13)
   @test getindices(v, (a = 1, c = 3)) === (a = 11, c = 13)

   t = (11, 12, 13)
   @test getindices(t, [1, 3]) == [11, 13]
   @test getindices(t, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
   @test getindices(t, (1, 3)) == (11, 13)
   @test getindices(t, (a = 1, c = 3)) === (a = 11, c = 13)

   nt = (a = 1, b = 2.0, c = "three")
   @test getindices(nt, [:a, :c]) == [1, "three"]
   @test getindices(nt, Dict(:aa => :a, :cc => :c)) == Dict(:aa => 1, :cc => "three")
   @test getindices(nt, (:a, :c)) == (1, "three")
   @test getindices(nt, (aa = :a, cc = :c)) == (aa = 1, cc = "three")
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
    setindices!(d4, "Someone", Dict(:aa => :a, :cc => :c))
    @test d4 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")

    d5 = copy(d)
    setindices!(d5, "Someone", (aa = :a, cc = :c))
    @test d5 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")

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

    v5 = copy(v)
    setindices!(v5, 20, (a = 1, c = 3))
    @test v5 == [20, 12, 20]
end