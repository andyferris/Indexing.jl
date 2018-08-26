using Indexing
if VERSION < v"0.7-"
    using Base.Test
else
    using Test
end

@testset "getindices" begin
    d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
    @test getindices(d, [:a, :c]) == ["Alice", "Charlie"]
    @test getindices(d, (:a, :c)) == ("Alice", "Charlie")
    @test getindices(d, Dict(:aa => :a, :cc => :c)) == Dict(:aa => "Alice", :cc => "Charlie")
    @static if VERSION > v"0.7-"
        @test getindices(d, (aa = :a, cc = :c)) == (aa = "Alice", cc = "Charlie")
    end
    @test getindices(d, :) == d

    v = [11, 12, 13]
    @test (getindices(v, 2)::Array{Int, 0})[] == 12
    @test getindices(v, [1, 3]) == [11, 13]
    @test getindices(v, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
    @test getindices(v, (1, 3)) === (11, 13)
    @static if VERSION > v"0.7-"
        @test getindices(v, (a = 1, c = 3)) === (a = 11, c = 13)
    end
    @test getindices(v, :) == v

    t = (11, 12, 13)
    @test getindices(t, [1, 3]) == [11, 13]
    @test getindices(t, Dict(:a => 1, :c => 3)) == Dict(:a => 11, :c => 13)
    @test getindices(t, (1, 3)) == (11, 13)
    @static if VERSION > v"0.7-"
        @test getindices(t, (a = 1, c = 3)) === (a = 11, c = 13)
    end
    @test getindices(t, :) == t

    @static if VERSION > v"0.7-"
        nt = (a = 1, b = 2.0, c = "three")
        @test getindices(nt, [:a, :c]) == [1, "three"]
        @test getindices(nt, Dict(:aa => :a, :cc => :c)) == Dict(:aa => 1, :cc => "three")
        @test getindices(nt, (:a, :c)) == (1, "three")
        @test getindices(nt, (aa = :a, cc = :c)) == (aa = 1, cc = "three")
        @test getindices(nt, :) == nt
    end
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

    @static if VERSION > v"0.7-"
        d5 = copy(d)
        setindices!(d5, "Someone", (aa = :a, cc = :c))
        @test d5 == Dict(:a => "Someone", :b => "Bob", :c => "Someone")
    end

    d6 = copy(d)
    setindices!(d6, "Someone", :)
    @test d6 == Dict(:a => "Someone", :b => "Someone", :c => "Someone")

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

    @static if VERSION > v"0.7-"
        v5 = copy(v)
        setindices!(v5, 20, (a = 1, c = 3))
        @test v5 == [20, 12, 20]
    end

    v6 = copy(v)
    setindices!(v6, 20, :)
    @test v6 == [20, 20, 20]
end

@testset "view" begin
    d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
    d2 = copy(d)
    
    @test view(d, [:a, :c])::ViewArray == ["Alice", "Charlie"]
    @test view(d, Dict(:aa => :a, :cc => :c))::ViewDict == Dict(:aa => "Alice", :cc => "Charlie")

    av = view(d, [:a, :c])
    @test parent(av) === d
    @test av[1] == "Alice"
    @test Indexing.axes(av) === (Base.OneTo(2),)
    av[1] = "Someone"
    @test d == Dict(:a => "Someone", :b => "Bob", :c => "Charlie")

    dv = view(d2, Dict(:aa => :a, :cc => :c))
    @test parent(dv) === d2
    @test dv[:aa] == "Alice"
    @test keys(dv) ⊆ [:aa, :cc] # Probably will want to change this
    @test length(keys(dv)) == 2
    @test haskey(dv, :aa)
    dv[:aa] = "No-one"
    @test d2 == Dict(:a => "No-one", :b => "Bob", :c => "Charlie")

    v = [11, 12, 13]

    @test view(v, Dict(:a =>1 , :c => 3))::ViewDict == Dict(:a => 11, :c => 13)
    
    dv2 = view(v, Dict(:a =>1 , :c => 3))
    @test parent(dv2) === v
    @test dv2[:a] == 11
    @test keys(dv2) ⊆ [:a, :c]
    @test length(keys(dv2)) == 2
    @test haskey(dv2, :a)
    @test first(dv2) === (:a => 11) || first(dv2) === (:c => 13)
    dv2[:a] = 21
    @test v == [21, 12, 13]


    @test ViewArray(d, [:b, :c])::ViewArray == ["Bob", "Charlie"]
    @test ViewVector(d, [:b, :c])::ViewVector == ["Bob", "Charlie"]
    @test ViewMatrix(d, [:b :c; :c :b])::ViewMatrix == ["Bob" "Charlie"; "Charlie" "Bob"]
end
