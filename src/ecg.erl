-module(ecg).
-mode(compile).

%% API exports
-export([main/1,
         run/2]).

main(Args) ->
    [Name | Modules] = Args,
    print("~ts\n", [run(Name, Modules)]).

run(Name, Modules) ->
    check_modules(Modules),
    {ok, Calls} = get_calls(Modules),
    %print("calls: ~p\n", [Calls]),
    make_dot(Name, Calls).

check_modules(Modules) ->
    case catch lists:all(fun
                             (true) -> true;
                             (Err)  -> throw(Err)
                         end, [ check_module(M) || M <- Modules ])
    of
        true -> ok;
        {_, _} = Reason -> error(Reason, [Modules])
    end.

check_module(MPath) ->
    case filelib:is_regular(MPath) of
        true -> true;
        false -> {cannot_access, MPath}
    end.

get_calls(Modules) ->
    {ok, _} = xref:start(xr()),
    [ {ok, _} = xref:add_module(xr(), M) || M <- Modules ],
    {ok, _} = xref:q(xr(), "E", [{verbose, false}]).

make_dot(Name, Edges) ->
    ["digraph ", Name, " {\n",
     style_header(),
     make_dot_(Edges),
     "}\n"].

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
