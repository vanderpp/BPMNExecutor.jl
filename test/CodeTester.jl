using BPMNExecutor

function showNodeElements(nodeElements)
    [begin println(typeof(el), " ", get_id(el)); end for el in nodeElements]
end

function parseBPMN()
    "./src/diagram.bpmn" |> retrieveTopProcess |> exploreFlow #|> showNodeElements
end

parsed = parseBPMN()
startEvent = findStartEvent(parsed)


#someTask = parsed[1].subnodes[2]
#print(taskGenerator(someTask))

#print(resumableGenerator("subProcess1"))