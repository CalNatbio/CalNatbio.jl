using CalNatbio
using Documenter

DocMeta.setdocmeta!(CalNatbio, :DocTestSetup, :(using CalNatbio); recursive=true)

makedocs(;
    modules=[CalNatbio],
    authors=".",
    sitename="CalNatbio.jl",
    format=Documenter.HTML(;
        canonical="https://CalNatbio.github.io/CalNatbio.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/CalNatbio/CalNatbio.jl",
    devbranch="master",
)
