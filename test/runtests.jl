using NestedTuples
using Test

@testset "NestedTuples.jl" begin
    x = (a = (a = :a, b = :b), q = (l = :l, u = :u))

    @test NestedTuples.exprify(x; rename=false) == ([:a, :b, :l, :u], :((a = (a = a, b = b), q = (l = l, u = u))))
    
    @test NestedTuples.flatten(x) == (:a, :b, :l, :u)

    @test NestedTuples.keysort(x) == (a = (a = :a, b = :b), q = (l = :l, u = :u))
    
    @test NestedTuples.leaf_setter(x)(1,2,3,4) == (a = (a = 1, b = 2), q = (l = 3, u = 4))

    @test NestedTuples.schema(x) == (a = (a = Symbol, b = Symbol), q = (l = Symbol, u = Symbol))
end
