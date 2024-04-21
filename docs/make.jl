using CalNatBio
using Documenter

DocMeta.setdocmeta!(CalNatBio, :DocTestSetup, :(using CalNatBio); recursive=true)

makedocs(;
    modules=[CalNatBio],
    authors="renilsonlisboa <renilsonlisboajunior@gmail.com> and contributors",
    sitename="CalNatBio.jl",
    format=Documenter.HTML(;
        canonical="https://renilsonlisboajunior@gmail.com.github.io/CalNatBio.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/renilsonlisboajunior@gmail.com/CalNatBio.jl",
    devbranch="master",
)
