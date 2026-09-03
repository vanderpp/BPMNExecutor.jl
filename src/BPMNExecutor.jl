module BPMNExecutor
    using XML

    export retrieveTopProcess, exploreFlow, showNodeElements, doCode

    include("datastructures.jl")
    include("bpmnExplorer.jl")

end
