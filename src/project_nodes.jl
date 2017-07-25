# This file is a part of JuliaFEM.
# License is MIT: see https://github.com/JuliaFEM/Mortar2D.jl/blob/master/LICENSE

"""
Find the projection of a slave node `xs`, having normal vector `ns`, onto master
elements with nodes (xm1, xm2).

## Mathematics

## References

- Yang2005

"""
function project_from_slave_to_master{T<:Number}(::Type{Val{:Seg2}}, xs::Vector{T}, ns::Vector{T}, xm1::Vector{T}, xm2::Vector{T})
    nom = ns[1]*(xm1[2] + xm2[2] - 2*xs[2]) - ns[2]*(xm1[1] + xm2[1] - 2*xs[1])
    denom = ns[1]*(xm1[2] - xm2[2]) + ns[2]*(xm2[1] - xm1[1])
    return nom/denom
end

"""
Find the projection of a master node `xm`, to the slave surface with nodes
(xs1, xs2), in direction of slave surface normal defined by (ns1, ns2).
"""
function project_from_master_to_slave{T<:Number}(::Type{Val{:Seg2}}, xm::Vector{T}, xs1::Vector{T}, xs2::Vector{T}, ns1::Vector{T}, ns2::Vector{T})

    nom_b = 2*ns1[1]*xm[2] - 2*ns1[1]*xs1[2] - 2*ns1[2]*xm[1] + 2*ns1[2]*xs1[1] - 2*ns2[1]*xm[2] + 2*ns2[1]*xs2[2] + 2*ns2[2]*xm[1] - 2*ns2[2]*xs2[1]
    denom_b = ns1[1]*xs1[2] - ns1[1]*xs2[2] - ns1[2]*xs1[1] + ns1[2]*xs2[1] - ns2[1]*xs1[2] + ns2[1]*xs2[2] + ns2[2]*xs1[1] - ns2[2]*xs2[1]
    nom_c = -2*ns1[1]*xm[2] + ns1[1]*xs1[2] + ns1[1]*xs2[2] + 2*ns1[2]*xm[1] - ns1[2]*xs1[1] - ns1[2]*xs2[1] - 2*ns2[1]*xm[2] + ns2[1]*xs1[2] + ns2[1]*xs2[2] + 2*ns2[2]*xm[1] - ns2[2]*xs1[1] - ns2[2]*xs2[1]
    denom_c = ns1[1]*xs1[2] - ns1[1]*xs2[2] - ns1[2]*xs1[1] + ns1[2]*xs2[1] - ns2[1]*xs1[2] + ns2[1]*xs2[2] + ns2[2]*xs1[1] - ns2[2]*xs2[1]

    a = 1.0
    b = nom_b / denom_b
    c = nom_c / denom_c
    d = b^2 - 4*a*c
    sols = [-b + sqrt(d), -b - sqrt(d)]/(2.0*a)
    info(sols)
    return sols[indmin(abs.(sols))]
end