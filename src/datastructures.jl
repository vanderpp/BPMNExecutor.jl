"""
The macro sharedNodeFields() is used to define the shared fields of the node structs.
It allows for easy modification of the fields in the future: change the macro definition instead of modifying each struct individually.
When defining a struct, inject the shared fields using this macro.
It is julia's alternative to type inheritance.
"""
macro sharedNodeFields()
    return esc(quote
        id::String
    end)
end

"""
Likewise, the macro sharedLinkFields() is used to define the shared fields of the nodes that figure in the diagram itself: 
StartEvents, EndEvents, Tasks and (Sub)Processess.
"""
macro sharedLinkFields()
    return esc(quote
        incoming::Vector{String}
        outgoing::Vector{String}
    end)
end

"""
We define this abstract "supertype" nodeType to allow for a generic getter and setter function for the shared fields of the node structs.
This is a julia alternative to type inheritance.
"""
abstract type nodeType end

"""
The different node types. When the list becomes too long, you can also divert to a macro to generate the structs.
In this case we don't apply the technique for readability and because the number of node types is small.
"""

mutable struct subProcess <: nodeType
    @sharedNodeFields
    @sharedLinkFields
    name::String 
    subnodes::Vector{Any}
    function subProcess(id::String)
        new(id,[],[], "", nodeType[])
    end
end

"""
Task is always a final leaf in the BPMN process tree.
The name attribute is used in our system to hold julia code, but only when the nodetype is a task. It is accessible via the alias taskCode.
"""
mutable struct task <: nodeType
    @sharedNodeFields
    @sharedLinkFields
    name::String
    function task(id::String)
        new(id,[],[], "")
    end
end

    """
    Following functions are needed to create the alias taskCode for the name attribute of the task struct.
    """
    function Base.getproperty(t::task, sym::Symbol)
        if sym === :taskCode
            return getfield(t, :name)
        end
        return getfield(t, sym)
    end

    function Base.setproperty!(t::task, sym::Symbol, val)
        if sym === :taskCode
            return setfield!(t, :name, val)
        end
        return setfield!(t, sym, val)
    end


mutable struct startEvent <: nodeType
    @sharedNodeFields
    @sharedLinkFields
    function startEvent(id::String)
        new(id,[],[])
    end
end

mutable struct endEvent <: nodeType
    @sharedNodeFields
    @sharedLinkFields
    function endEvent(id::String)
        new(id,[],[])
    end
end

mutable struct sequenceFlow <: nodeType
    @sharedNodeFields
    sourceRef::String
    targetRef::String
    function sequenceFlow(id::String)
        new(id, "", "") 
    end
end

"""
Generic getter/setter functions for the node structs.
"""
get_id(node::nodeType) = node.id

"""
Using a dictionary, we map the node types expressed in the BPMN XML file to the corresponding Julia types. 
This allows for easy extension of the code to support new node types.
"""
nodetypes = Dict(
    "bpmn:subProcess" => subProcess
    ,"bpmn:task" => task
    ,"bpmn:startEvent" => startEvent
    ,"bpmn:endEvent" => endEvent
    ,"bpmn:sequenceFlow" => sequenceFlow
    #,"bpmn:incoming" => nodeType
    #,"bpmn:outgoing" => nodeType
)