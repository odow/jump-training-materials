using Literate
# See https://fredrikekre.github.io/Literate.jl/v2/tips/#admonitions-compatibility
function admonition(str, name)
    return replace(str, "!!! $(lowercase(name))" => "**$name**")
end
function admonitions(str)
    str = admonition(str, "Note")
    str = admonition(str, "Tip")
    str = admonition(str, "Warning")
    str = admonition(str, "Info")
    return str
end
for file in filter(f -> endswith(f, ".jl"), readdir(@__DIR__))
    if file != "literate.jl"
        Literate.notebook(
            joinpath(@__DIR__, file),
            dirname(@__DIR__);
            execute = false,
            preprocess = admonitions,
        )
    end
end
