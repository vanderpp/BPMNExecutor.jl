using BPMNExecutor

function showNodeElements(nodeElements)
    [begin println(typeof(el), " ", get_id(el)); end for el in nodeElements]
end

function doCode()
    "./src/diagram.bpmn" |> retrieveTopProcess |> exploreFlow #|> showNodeElements
end

doCode()