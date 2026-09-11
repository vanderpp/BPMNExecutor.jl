module BPMNExecutor
    using XML

    export retrieveTopProcess, exploreFlow, showNodeElements, doCode
    export topScopeGenerator, resumableGenerator, taskGenerator, findStartEvent, findNextNode

    include("datastructures.jl")
    include("parser.jl")
    include("generator.jl")

end
