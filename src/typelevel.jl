using NamedTupleTools: namedtuple

ntkeys(::Type{NamedTuple{K,V}}) where {K, V} = K
ntvaltype(::Type{NamedTuple{K,V}}) where {K, V} = V

export schema

"""
    schema(::Type)
    
`schema` turns a type into a value that's easier to work with.

Example:

    julia> nt = (a=(b=[1,2],c=(d=[3,4],e=[5,6])),f=[7,8]);

    julia> NT = typeof(nt)
    NamedTuple{(:a, :f),Tuple{NamedTuple{(:b, :c),Tuple{Array{Int64,1},NamedTuple{(:d, :e),Tuple{Array{Int64,1},Array{Int64,1}}}}},Array{Int64,1}}}

    julia> schema(NT)
    (a = (b = Array{Int64,1}, c = (d = Array{Int64,1}, e = Array{Int64,1})), f = Array{Int64,1})
"""
function schema end

function schema(NT::Type{NamedTuple{names, T}}) where {names, T}
    return namedtuple(ntkeys(NT), schema(ntvaltype(NT)))
end

function schema(TT::Type{T}) where {T <: Tuple} 
    return schema.(Tuple(TT.types))
end

schema(t::T) where {T <: Tuple} = schema(T) 

schema(t::T) where {T <: NamedTuple} = schema(T) 


schema(T) = T
