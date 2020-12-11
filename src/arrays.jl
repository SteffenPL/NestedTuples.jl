export TupleArray

struct TupleArray{T,N,X} 
    data :: X
end

export unwrap

unwrap(ta::TupleArray) = getfield(ta, :data)
unwrap(x) = x

function TupleArray(x)
    flattened = flatten(x)
    @assert allequal(size.(flattened)...)

    T = typeof(modify(arr -> arr[1], x, Leaves()))
    N = length(axes(flattened[1]))
    X = typeof(x)
    return TupleArray{T,N,X}(x)
end

TupleArray{T}(x...) where {T} = leaf_setter(T)(x...)

import Base

# function Base.show(io, n::TupleArray)
#     print(io, "TupleArray("

#     print(io, ")"


function Base.getindex(x::TupleArray, j)
        
    # TODO: Bounds checking doesn't affect performance, am I doing it right?
    Base.@propagate_inbounds function f(arr)
        @boundscheck all(j .∈ axes(arr))
        return @inbounds arr[j]
    end

    modify(f, unwrap(x), Leaves())
end

function Base.length(ta::TupleArray)
    length(flatten(unwrap(ta))[1])
end

function Base.reshape(ta::TupleArray, newshape)
    x = unwrap(ta)
    TupleArray(modify(arr -> reshape(arr, newshape), x, Leaves()))
end

function Base.size(ta::TupleArray)
    size(flatten(unwrap(ta))[1])
end

# TODO: Make this pass @code_warntype
Base.getproperty(ta::TupleArray, k::Symbol) = maybewrap(getproperty(unwrap(ta), k))

maybewrap(t::Tuple) = TupleArray(t)
maybewrap(t::NamedTuple) = TupleArray(t)
maybewrap(t) = t

flatten(ta::TupleArray) = TupleArray(flatten(unwrap(ta)))

leaf_setter(ta::TupleArray) = TupleArray ∘ leaf_setter(unwrap(ta))
