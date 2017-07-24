-module(ecg_codepath).

-export(infer/1).

-import(filelib, [is_dir/1]).

infer(Base0) ->
    Base = filename:dirname(filename:absname(Base0)),
    lists:usort([ infer(Base, deps, "deps") ] ++
                [ infer(Base, build, "_build") ]).

infer(Base, Deps) ->
    case is_dir(filename:join([Base, Deps])) of
        false -> [];
        true -> filelib:wildcard()
    end.
