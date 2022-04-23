

function solve(instance; method="heur")
    command = `java -jar tsp-drones-heur/target/tsp-drones-heur-1.0.0-jar-with-dependencies.jar TSP-D-Instances/$(instance) mysol.sol concorde $(method) 7`
    
    run(command)

    lines = readlines("mysol.sol")
    cost = parse(Float64, split(lines[end])[end-1])
    return cost
end




function test(dist; method="heur")

    filenames = Dict()
    filenames[10] = ["$(dist)-$(50 + i)-n10.txt" for i in 1:10]
    filenames[20] = ["$(dist)-$(60 + i)-n20.txt" for i in 1:10]
    filenames[50] = ["$(dist)-$(70 + i)-n50.txt" for i in 1:10]
    filenames[75] = ["$(dist)-$(80 + i)-n75.txt" for i in 1:10]
    filenames[100] = ["$(dist)-$(90 + i)-n100.txt" for i in 1:10]
    filenames[175] = ["$(dist)-$(100 + i)-n175.txt" for i in 1:10]
    filenames[250] = ["$(dist)-$(110 + i)-n250.txt" for i in 1:10]
    
    n_nodes = [10 20 50 75 100 175 250]

    for n in n_nodes
        costs = Float64[]
        t = time()
        for file in filenames[n]
            cost = solve(joinpath(dist, file), method=method)
            push!(costs, cost)
            @show file, cost
        end
        @show mean(costs)

        avg_time = (time() - t) / 10 
        @show avg_time 

        open("$dist-n$n-LS-Agatz.txt", "w") do io 
            println(io, costs)
            println(io, mean(costs))
            println(io, avg_time)
        end        
    end
end


# filenames = ["uniform/uniform-$i-n11.txt" for i in 1:10]
# test(filenames)

test("uniform")
test("singlecenter")
test("doublecenter")