"""
The following functions analyse the BPMN XML file and extract the relevant information to create the node structs.
"""
function retrieveTopProcess(path::String)
    doc = read(path, Node)
    XMLcontent = children(doc) # XMLcontent contains the XML declaration and the <bpnm:definitions> node
    bpmn_definitions = XMLcontent[2] # <bpmn:definitions> contains the subnodes <bpmn:process> and <bpmndi:BPMNDiagram>
    bpmn_process = children(bpmn_definitions)[1]
    return bpmn_process
end

function exploreFlow(Node)
    # Local function definitions 
    # For registering incoming and outgoing flows for: startevent, stopevent, task and subprocess nodes.
    function registerFlows(nodeStruct, Node, flowType)
        Flows = filter(x -> tag(x) == flowType, children(Node))
        for Flow in Flows
            innerValue = simple_value(Flow)
            if flowType == "bpmn:incoming"
                push!(nodeStruct.incoming, innerValue)
            elseif flowType == "bpmn:outgoing"
                push!(nodeStruct.outgoing, innerValue)
            end
        end
    end

    function registerInFlows(nodeStruct, Node)
        registerFlows(nodeStruct, Node, "bpmn:incoming")
    end

    function registerOutFlows(nodeStruct, Node)
        registerFlows(nodeStruct, Node, "bpmn:outgoing")
    end # End of local function definitions

    nodeElements = []
    for child in children(Node)
        
        currentNodeType = tag(child)

        #if currentNodeType == "bpmn:incoming" || currentNodeType == "bpmn:outgoing"
        if currentNodeType ∉ keys(nodetypes)
            println("Skipping node type: $currentNodeType no instantiator function available")
            continue # Skip incoming and outgoing nodes, they are handled in the parent node
        end

        nodeType = nodetypes[currentNodeType]

        id = attributes(child)["id"] # id exists always for the 5 types defined above
        nodeStruct = nodeType(id)

        #println(nodeStruct isa Union{subProcess, task, startEvent, endEvent, sequenceFlow})
    
        if nodeType == sequenceFlow
            nodeStruct.sourceRef = attributes(child)["sourceRef"]
            nodeStruct.targetRef = attributes(child)["targetRef"]
        
        elseif nodeType == task
            nodeStruct.taskCode = attributes(child)["name"]

        elseif nodeType == subProcess
            registerInFlows(nodeStruct, child)
            registerOutFlows(nodeStruct, child)
            nodeStruct.name = attributes(child)["name"]
            nodeStruct.subnodes = exploreFlow(child) # Recursively explore the subnodes of the subprocess

        elseif nodeType == startEvent
            registerOutFlows(nodeStruct, child)

        elseif nodeType == endEvent
            registerInFlows(nodeStruct, child)
        else
            println("Unknown node type: $currentNodeType")
        end
        
        push!(nodeElements, nodeStruct) 
    end
    return nodeElements
end