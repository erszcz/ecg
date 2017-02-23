-module(ecg).
-mode(compile).

%% API exports
-export([main/1]).

%% Top-level commands
-export([full_graph/1,
         component/2]).

main(["full", ModS])                 -> full_graph(ModS);
main(["component", Component, ModS]) -> component(Component, ModS).

full_graph(ModS) ->
    {ok, Calls} = get_calls(ModS),
    %print("calls: ~p\n", [Calls]),
    ok = make_dot(ModS, Calls).

component(ComponentSpec, ModS) ->
    {ok, Calls} = get_calls(ModS),
    G = digraph:new(),
    [ begin digraph:add_vertex(G, From),
            digraph:add_vertex(G, To),
            digraph:add_edge(G, From, To) end
      || {From, To} <- Calls ],
    Components = digraph_utils:components(G),
    print("components: ~p\n", [Components]),
    SubG = digraph_utils:subgraph(G, select_component(ComponentSpec, Components)),
    print("edges: ~p\n", [digraph:edges(SubG)]).

select_component(ComponentSpec, Components) ->
    CompMFA = parse_component_spec(ComponentSpec),
    %% Assert the list is one element long. It should be.
    [Needle] = [ Comp || Comp <- Components, lists:member(CompMFA, Comp) ],
    Needle.

parse_component_spec(ComponentSpec) ->
    [MS, FS, AS] = string:tokens(ComponentSpec, ":/"),
    {list_to_atom(MS), list_to_atom(FS), list_to_integer(AS)}.

get_calls(ModS) ->
    Mod = list_to_atom(ModS),
    ModFile = code:which(Mod),
    {ok, _} = xref:start(xr()),
    {ok, _} = xref:add_module(xr(), ModFile),
    {ok, _} = xref:q(xr(), lists:flatten(["E | ", ModS]),
                     [{verbose, false}]).

make_dot(Name, Edges) ->
    Dot = ["digraph ", Name, " {\n",
           make_dot_(Edges),
           "}\n"],
    %print("dot: ~p\n", [Dot]),
    %print("dot file: ~p\n", [DotFile]),
    print("~ts\n", [Dot]).

make_dot_(Edges) ->
    [ ["  ", format_mfa(From), " -> ", format_mfa(To), ";\n"]
      || {From, To} <- Edges ].

format_mfa({M, F, A}) -> io_lib:format("\"~ts:~ts/~b\"", [M, F, A]).

print(Fmt, Args) ->
    io:format(Fmt, Args).

%% xref handle
xr() -> ?MODULE.
