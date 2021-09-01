The files in this directory are the source files used to construct the
notebooks. They don't contain anything that is not available via the notebooks.

```julia
using Literate
for file in filter(f -> endswith(f, ".jl"), readdir(@__DIR__))
    Literate.notebook(
        joinpath(@__DIR__, file),
        dirname(@__DIR__);
        execute = false,
    )
end
```
