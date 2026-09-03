using BPMNExecutor
using Documenter

DocMeta.setdocmeta!(BPMNExecutor, :DocTestSetup, :(using BPMNExecutor); recursive=true)

makedocs(;
    modules=[BPMNExecutor],
    authors="Piet VAN DER PAELT <piet.van.der.paelt@vub.be>",
    repo="https://github.com/vanderpp/BPMNExecutor.jl/blob/{commit}{path}#{line}",
    sitename="BPMNExecutor.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://vanderpp.github.io/BPMNExecutor.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vanderpp/BPMNExecutor.jl",
    devbranch="main",
)
