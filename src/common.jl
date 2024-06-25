## Some common functions, constants, macros

# auxiliary functions/constants
found_a_bug() = error("you just found a bug in the ArgParse module, please report it.")
const nbspc = '\u00a0'
const nbsps = "$nbspc"
println_unnbsp(io::IO, args...) = println(io, map(s->replace(s, nbspc => ' '), args)...)

macro defaults(opts, ex)
    @assert ex.head == :block
    lines = filter(x->!(x isa LineNumberNode), ex.args)
    @assert all(x->Meta.isexpr(x, :(=)), lines)

    opts = esc(opts)
    # Transform the opts array into a Dict
    exret = :($opts = Dict{Symbol,Any}($opts))
    # Initialize the checks
    found = esc(gensym("found"))
    exret = quote
        $exret
        $found = Dict{Symbol,Bool}(k => false for (k,v) in $opts)
    end

    for y in lines
        sym = y.args[1]
        qsym = Expr(:quote, sym)
        exret = quote
            $exret
            if haskey($opts, $qsym)
                $(esc(sym)) = $opts[$qsym]
                $found[$qsym] = true
            else
                $(esc(y))
            end
        end
    end
    exret = quote
        $exret
        for (k,v) in $found
            v || serror("unknown description field: $k")
        end
    end
    exret
end

# Wrapper function to lower markdown strings to REPL representation
function string_format(s::Markdown.MD; width::Int)
    buf = IOBuffer()
    context = IOContext(buf, :color => true, :displaysize => (100, width))
    repr("text/plain", s; context=context)

    # NOTE: repr() above automatically indents the string by 2 spaces. We can
    # remove the indentation using Base.unindent() as follows, but the results
    # are inconsistent with :color => true enabled when s contains subheadings,
    # because repr() inserts the ANSI escape code enabling the bold font
    # *before* the leading two spaces.

    # ansi_escaped = repr("text/plain", s; context=context)
    # unindented = Base.unindent(ansi_escaped, 2)
end
string_format(s::AbstractString; width::Int) = TextWrap.wrap(s; width=width)
