using Indexing
using Base.Test

@testset "getindices" begin
   d = Dict(:a => "Alice", :b => "Bob", :c => "Charlie")
   @test getindices(d, [:a, :c]) == ["Alice", "Charlie"]
   @test getindices(d, (:a, :c)) == ("Alice", "Charlie")
   @test_broken getindices(d, Dict(:a => :a, :c => :c)) == Dict(:a => "Alice", :c => "Charlie")
end