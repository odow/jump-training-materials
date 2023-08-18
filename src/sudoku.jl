# # Sudoku

using JuMP
import HiGHS
import HTTP
import JSON

#-

function endpoint_api_solve(request::HTTP.Request)
    data = JSON.parse(String(request.body))
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    @variable(model, x[i = 1:9, j = 1:9, k = 1:9], Bin)
    @constraint(model, [i = 1:9, j = 1:9], sum(x[i, j, :]) == 1)
    @constraint(model, [i = 1:9, k = 1:9], sum(x[i, :, k]) == 1)
    @constraint(model, [j = 1:9, k = 1:9], sum(x[:, j, k]) == 1)
    @constraint(
        model,
        [i = 1:3:7, j = 1:3:7, k = 1:9],
        sum(x[r, c, k] for r in i:(i+2), c in j:(j+2)) == 1,
    )
    for (i, j, k) in data
        fix(x[i, j, k], 1.0)
    end
    optimize!(model)
    if termination_status(model) != OPTIMAL
        return Dict("status" => "failure")
    end
    ret = Dict{String,Any}("status" => "success")
    ret["solution"] = [
        round(Int, sum(k * value(x[i, j, k]) for k in 1:9))
        for i in 1:9
        for j in 1:9
    ]
    return HTTP.Response(200, JSON.json(ret))
end

#-

function endpoint_index(request::HTTP.Request)
    page = read(joinpath(@__DIR__, "sudoku.html"), String)
    return HTTP.Response(200, page)
end

#-

function run_server(host, port)
    server = HTTP.Sockets.listen(host, port)
    router = HTTP.Router()
    HTTP.register!(router, "GET", "/", endpoint_index)
    HTTP.register!(router, "POST", "/api/solve", endpoint_api_solve)
    HTTP.serve!(router, host, port; server = server)
    return server
end

#-

server = run_server(HTTP.ip"127.0.0.1", 8080)
