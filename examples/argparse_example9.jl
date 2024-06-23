# example 9: minimal options/arguments, markdown strings as help text

using ArgParse
using Markdown

function main(args)

    # initialize the settings (the description is for the help screen)
    s = ArgParseSettings(description = md"Example 9 for `argparse.jl`: Markdown strings.")

    @add_arg_table! s begin
        "--opt1"               # an option (will take an argument)
        "--opt2", "-o"         # another option, with short form
        "src"                  # a positional argument
           help = md"The **source** of all our troubles"
        "dest"                 # a positional argument
           help = md"The **destination** where we want to send them"
    end

    parsed_args = parse_args(s) # the result is a Dict{String,Any}
    println("Parsed args:")
    for (key,val) in parsed_args
        println("  $key  =>  $(repr(val))")
    end
end

main(ARGS)
