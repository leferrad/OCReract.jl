using Documenter
using OCReract

makedocs(;
    modules=[OCReract],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/leferrad/OCReract.jl/blob/{commit}{path}#L{line}",
    sitename="OCReract.jl",
    authors="Leandro Ferrado"
)

deploydocs(;
    repo="github.com/leferrad/OCReract.jl",
)
