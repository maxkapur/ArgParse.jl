# test 15: markdown in description, epilog, and help text

using Markdown

@testset "test 15" begin

function ap_settings15()

    s = ArgParseSettings(
        description=md"""
        Test 15 for `argparse.jl`: Markdown strings. This description text uses
        various Markdown features such as **strong text**, text with *emphasis*,
        `code snippets`, and math: ``y = mx + b``.

        ## Subheading

        The following list should be numbered automatically:

        1. Here
        1. Is
        1. A
        1. List
        """,
        epilog=md"See [our website](https://example.com) for more information.",
        exc_handler = ArgParse.debug_handler
    )

    @add_arg_table! s begin
        "--opt1"
            arg_type = Int
            help = "a flag with String helptext"
        "--opt2"
            arg_type = String
            help = md"a flag with ~~String~~ **markdown** helptext"
    end

    return s
end

let s = ap_settings15()
    ap_test15(args) = parse_args(args, s)

    @test stringhelp(s) == "usage: argparse_test15.jl [--opt1 OPT1] [--opt2 OPT2]\n\n  Test 15 for \e[36margparse.jl\e[39m: Markdown strings. This description text\n  uses various Markdown features such as \e[1mstrong text\e[22m, text with\n  \e[4memphasis\e[24m, \e[36mcode snippets\e[39m, and math: \e[35my = mx + b\e[39m.\n\n\e[1m  Subheading\e[22m\n\e[1m  ==========\e[22m\n\n  The following list should be numbered automatically:\n\n    1. Here\n\n    2. Is\n\n    3. A\n\n    4. List\n\noptional arguments:\n  --opt1 OPT1  a flag with String helptext (type: Int64)\n  --opt2 OPT2  a flag with ~~String~~ \e[1mmarkdown\e[22m helptext\n\n  See our website (https://example.com) for more information.\n\n"
    @test ap_test15([]) == Dict{String,Any}("opt1"=>nothing, "opt2"=>nothing)
    @test ap_test15(["--opt1", "33"]) == Dict{String,Any}("opt1"=>33, "opt2"=>nothing)
    @test ap_test15(["--opt2", "foo"]) == Dict{String,Any}("opt1"=>nothing, "opt2"=>"foo")
    @test ap_test15(["--opt1", "33", "--opt2", "foo"]) == Dict{String,Any}("opt1"=>33, "opt2"=>"foo")
end

end
