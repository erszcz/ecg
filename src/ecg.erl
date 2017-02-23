-module(ecg).
-mode(compile).

%% API exports
-export([main/1]).

main([ModS]) ->
    {ok, Calls} = get_calls(ModS),
    %print("calls: ~p\n", [Calls]),
    ok = make_dot(ModS, Calls).

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
