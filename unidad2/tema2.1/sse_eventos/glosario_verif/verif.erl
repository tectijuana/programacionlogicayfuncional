-module(verif).
-export([main/0]).
main() ->
    {ok, B} = file:read_file("datos.json"),
    Filas = json:decode(B),
    Res = [ver(F) || F <- Filas],
    Mal = [R || R <- Res, R =/= ok],
    io:format("~b filas, ~b fallos~n", [length(Res), length(Mal)]),
    [io:format("FALLA: ~p~n", [M]) || M <- Mal],
    halt(case Mal of [] -> 0; _ -> 1 end).
ev(Str) ->
    {ok, T, _} = erl_scan:string(Str ++ "."),
    {ok, E} = erl_parse:parse_exprs(T),
    {value, V, _} = erl_eval:exprs(E, []),
    V.
ver([_G, Expr, Esperado, _D]) ->
    try
        case {ev(binary_to_list(Expr)), ev(binary_to_list(Esperado))} of
            {X, X} -> ok;
            {Got, Want} -> {Expr, got, Got, want, Want}
        end
    catch C:R -> {Expr, C, R}
    end.
