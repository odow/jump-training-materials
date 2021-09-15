# Demo a SIIP example from scratch

I'm going to demo this live. Hopefully it works!

https://nrel-siip.github.io/PowerSystems.jl/stable/quick_start_guide/

https://nrel-siip.github.io/PowerSystems.jl/stable/modeler_guide/generated_modeling_with_JuMP/

 Setup a new package environment

```julia
using Plots, PowerSystems, JuMP, Ipopt
```

```julia
DATA_DIR = download(PowerSystems.UtilsData.TestData, folder = pwd())
```

```julia
; ls data
```

Go look at the data in the directory

```julia
system_data = System(joinpath(DATA_DIR, "matpower/case5_re.m"))
```

```julia
add_time_series!(system_data, joinpath(DATA_DIR,"forecasts/5bus_ts/timeseries_pointers_da.json"))
```

Now compare the system data
```julia
system_data
```

We can save this
```julia
to_json(system_data, "system_data.json")
```

If you want it later
```julia
system = System("system_data.json")
```

Let's explore the system
```julia
get_components(ThermalStandard, system)
```

```julia
get_components(RenewableGen, system)
```

```julia
generators = collect(get_components(ThermalStandard, system));
```

```julia
generators[1]
```

```julia
renewables = collect(get_components(RenewableGen, system))
```

SIIP uses functions to get data
```julia
get_name.(generators)
```

```julia
get_time_series_values(SingleTimeSeries, renewables[1], "max_active_power")
```

You can tab complete `get_`
```julia
get_reactive_power.(generators)
```

Let's start building the model
```julia
ed_m = Model(Ipopt.Optimizer)
```

```
time_periods = 1:24
```

```julia
thermal_gens_names = get_name.(get_components(ThermalStandard, system))
```

```julia
@variable(ed_m, pg[g in thermal_gens_names, t in time_periods] >= 0)
```

```julia
for g in get_components(ThermalStandard, system), t in time_periods
    name = get_name(g)
    @constraint(ed_m, pg[name, t] >= get_active_power_limits(g).min)
    @constraint(ed_m, pg[name, t] <= get_active_power_limits(g).max)
end
```

```julia
net_load = zeros(length(time_periods))
for g in get_components(RenewableGen, system)
    net_load -= get_time_series_values(SingleTimeSeries, g, "max_active_power")
end
```

```julia
for g in get_components(StaticLoad, system)
    net_load += get_time_series_values(SingleTimeSeries, g, "max_active_power")
end
```

```julia
for t in time_periods
    @constraint(ed_m, sum(pg[g, t] for g in thermal_gens_names) == net_load[t])
end
```

```julia
@objective(ed_m, Min, sum(
        pg[get_name(g), t]^2*get_cost(get_variable(get_operation_cost(g)))[1] +
        pg[get_name(g), t]*get_cost(get_variable(get_operation_cost(g)))[2]
        for g in get_components(ThermalGen, system), t in time_periods
            )
)
```

```julia
optimize!(ed_m)
```

```julia
value.(pg)
```

```julia
using Plots

pg_v = value.(pg)
collect(pg_v["Solitude", :])

plot(dpi=600)
for name in thermal_gens_names
    plot!(collect(pg_v[name, :]), label = name)
end
plot!(
    xlabel = "Time",
    ylabel = "pg",
)
```
