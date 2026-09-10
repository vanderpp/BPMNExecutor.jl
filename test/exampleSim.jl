@resumable function car(sim::Environment)

            while true
                parkingduration = rand(1.0:10.0)
                @yield timeout(sim, parkingduration)

                waitduration = rand(1.0:10.0)
                @yield timeout(sim, waitduration)
                
                tripduration = rand(1.0:10.0)
                @yield timeout(sim, tripduration)
                
                @yield @process trafficlight(sim)
            end
end true

@resumable function trafficlight(sim::Environment)
        trafficlightwaittime = rand(1.0:10.0)
        @yield timeout(sim, trafficlightwaittime)
end true

@info "$(@__MODULE__): Starting the simulation run"
sim2 = Simulation()
@process car(sim2)
@runPersisted(sim2, 1000)
return ("sim ended $(now())",sim2.monitored)