-module(semi_modelo_tests).
-include_lib("eunit/include/eunit.hrl").

m() -> semi_modelo:nuevo({0.0, 0.0}, {10.0, 20.0}, 0.5).

botones_test() ->
    A = semi_modelo:boton(a, m()),
    ?assertEqual(detenido, semi_modelo:estado(A)),
    ?assertEqual(rodando, semi_modelo:estado(semi_modelo:boton(a, A))),
    B = semi_modelo:boton(b, m()),
    ?assertEqual(sos, semi_modelo:estado(B)),
    ?assertEqual(sos, semi_modelo:estado(semi_modelo:boton(a, B))),   %% A ignorado en SOS
    ?assertEqual(rodando, semi_modelo:estado(semi_modelo:boton(b, B))).

no_avanza_si_no_rueda_test() ->
    M = semi_modelo:boton(a, m()),
    ?assertEqual(M, semi_modelo:paso(0.1, M)).

llegada_invierte_ruta_test() ->
    M = semi_modelo:paso(0.1, semi_modelo:nuevo({0.0, 0.0}, {10.0, 20.0}, 1.0)),
    ?assertEqual({10.0, 20.0}, semi_modelo:posicion(M)).   %% origen = ex destino, p = 0.0

logo_conserva_posicion_test() ->
    M = m(),
    {La, Lo} = semi_modelo:posicion(M),
    {La2, Lo2} = semi_modelo:posicion(semi_modelo:boton(logo, M)),
    ?assert(abs(La - La2) < 1.0e-9), ?assert(abs(Lo - Lo2) < 1.0e-9).

ordenes_test() ->
    D = semi_modelo:orden(<<"detener">>, m()),
    ?assertEqual(detenido, semi_modelo:estado(D)),
    ?assertEqual(rodando, semi_modelo:estado(semi_modelo:orden(<<"reanudar">>, D))),
    ?assertEqual(m(), semi_modelo:orden(<<"basura">>, m())),
    S = semi_modelo:boton(b, m()),
    ?assertEqual(S, semi_modelo:orden(<<"detener">>, S)).          %% no pisa un SOS

velocidad_test() ->
    ?assertEqual(71, semi_modelo:velocidad(m(), 0)),
    ?assertEqual(0, semi_modelo:velocidad(semi_modelo:boton(a, m()), 29)).

%% Propiedad (sin librerias): para toda secuencia de eventos, p sigue en [0,1] y el estado es valido.
invariantes_test() ->
    Eventos = [{b, a}, {b, b}, {b, logo}, {p, 0.005}, {o, <<"detener">>}, {o, <<"reanudar">>}],
    lists:foreach(fun(Seed) ->
        _ = rand:seed(exsss, {Seed, 1, 1}),
        M = lists:foldl(fun(_, Acc) ->
                 case lists:nth(rand:uniform(6), Eventos) of
                     {b, B} -> semi_modelo:boton(B, Acc);
                     {p, D} -> semi_modelo:paso(D, Acc);
                     {o, O} -> semi_modelo:orden(O, Acc)
                 end end, m(), lists:seq(1, 500)),
        ?assert(lists:member(semi_modelo:estado(M), [rodando, detenido, sos])),
        {La, Lo} = semi_modelo:posicion(M),
        ?assert(La >= -0.001 andalso La =< 10.001 andalso Lo >= -0.001 andalso Lo =< 20.001)
    end, lists:seq(1, 200)).

