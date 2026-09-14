module BPMNExecutor
    using XML

    export retrieveTopProcess, exploreFlow, showNodeElements, doCode
    export topScopeGenerator, resumableGenerator, taskGenerator, findStartEvent, findNextNode, getRandVarName, parseBPMN, topLevelResumableGenerator

    include("datastructures.jl")
    include("parser.jl")
    include("navigation.jl")
    include("codeGenerator.jl")

end
