"""
parseBPMN() accepts the path to a BPMN diagram and returns the parsed process as an array of node elements. 
The parsing is done by the retrieveTopProcess() and exploreFlow() functions.
"""
function parseBPMN()
    "./src/diagram.bpmn" |> retrieveTopProcess |> exploreFlow
end
"""
A process always starts with a startEvent node. The findStartEvent() function 
accepts the parsed BPMN process and returns the startEvent node for that process 
(i.e. the least deep start node in the parsed process). 
There should always be one startEvent node in a BPMN process, so we stop when the first is encountered. 
If no startEvent node is found, the function returns nothing.
"""
function findStartEvent(parsed::Array{Any,1})
    for node in parsed
        if node isa startEvent
            return node
        end
    end
    return nothing
end

"""
findNextNode() accepts a node and the parsed BPMN process. 
It returns the next node in the process flow.
"""
function findNextNode(node::BPMNExecutor.nodeType, parsed::Array{Any,1})
    if node isa BPMNExecutor.startEvent
        nextFlowId = node.outgoing[1]
        nextFlow = filter(x -> x.id == nextFlowId, parsed)[1]
        nextNodeId = nextFlow.targetRef
        nextNode = filter(x -> x.id == nextNodeId, parsed)[1]
        return nextNode
    end
end