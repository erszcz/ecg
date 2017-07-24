-module(ecg).
-mode(compile).

%% API exports
-export([main/1]).

main(Args) ->
    [Name | Modules] = Args,
    run(Name, Modules).

run(Name, Modules) ->
    {ok, Calls} = get_calls(Modules),
    %print("calls: ~p\n", [Calls]),
    ok = make_dot(Name, Calls).

get_calls(Modules) ->
    {ok, _} = xref:start(xr()),
    [ {ok, _} = xref:add_module(xr(), M) || M <- Modules ],
    {ok, _} = xref:q(xr(), "E", [{verbose, false}]).

make_dot(Name, Edges) ->
    Dot = ["digraph ", Name, " {\n",
           style_header(),
           make_dot_(Edges),
           "}\n"],
    %print("dot: ~p\n", [Dot]),
    %print("dot file: ~p\n", [DotFile]),
    print("~ts\n", [Dot]).

style_header() ->
    ["  ranksep=\"2.0 equally\";"].

make_dot_(Edges) ->
    [ ["  ", format_mfa(From), " -> ", format_mfa(To), ";\n"]
      || {From, To} <- Edges ].

format_mfa({M, F, A}) -> io_lib:format("\"~ts:~ts/~b\"", [M, F, A]).

print(Fmt, Args) ->
    io:format(Fmt, Args).

%% xref handle
xr() -> ?MODULE.
