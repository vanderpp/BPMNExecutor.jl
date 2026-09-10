function topScopeGenerator(topProcess::String)
    codeStr = """
    begin   
        @info "\$(@__MODULE__): Starting the simulation run"
        sim2 = Simulation()
        @process \$topProcess(sim2)
        @runPersisted(sim2, 1000)
        return ("sim ended \$(now())",sim2.monitored)
    end
    """ 
    return codeStr
end

function resumableGenerator(subProcessName::String)
    codeStr = """
    begin
        @resumable function $subProcessName(sim::Environment)
        # todo: inner code here...
        end true
    end
    """
    return codeStr
end