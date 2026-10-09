-module(fix_tests).
-include_lib("eunit/include/eunit.hrl").

f(Seq, La, Lo) -> #{id => 1, seq => Seq, lat => La, lon => Lo, kmh => 80, hdop10 => 12, sats => 9, estado => rodando}.
p(Seq, La, Lo) -> #{seq => Seq, lat => La, lon => Lo}.

parsea_test() ->
    ?assertMatch({ok, #{id := 7, seq := 3, lat := 19.4, kmh := 85, sats := 9, estado := rodando}},
                 fix:parsear(<<"7|3|19.4|-99.1|85|12|9|rodando">>)),
    ?assertEqual(error, fix:parsear(<<"basura">>)),
    ?assertEqual(error, fix:parsear(<<"7|3|1.0|2.0|3|12|9|hack">>)),
    ?assertEqual(error, fix:parsear(<<"x|3|1.0|2.0|3|12|9|sos">>)).

primero_test() -> ?assertEqual({ok, 0}, fix:evaluar(f(0, 19.0, -99.0), undefined)).
consecutivo_test() -> ?assertEqual({ok, 0}, fix:evaluar(f(5, 19.01, -99.0), p(4, 19.0, -99.0))).
huecos_test() -> ?assertEqual({ok, 3}, fix:evaluar(f(9, 19.04, -99.0), p(5, 19.0, -99.0))).
duplicado_test() -> ?assertEqual({descartar, seq_viejo}, fix:evaluar(f(5, 19.0, -99.0), p(5, 19.0, -99.0))).
viejo_test() -> ?assertEqual({descartar, seq_viejo}, fix:evaluar(f(40, 19.0, -99.0), p(50, 19.0, -99.0))).
reinicio_test() -> ?assertEqual({ok, reinicio}, fix:evaluar(f(1, 19.0, -99.0), p(200, 19.0, -99.0))).
rango_test() ->
    ?assertEqual({descartar, fuera_de_rango}, fix:evaluar(f(1, 91.0, 0.0), undefined)),
    ?assertEqual({descartar, fuera_de_rango}, fix:evaluar(f(1, 0.0, 181.0), undefined)).
salto_test() ->   %% ~120 km en un solo paso de seq: imposible
    ?assertEqual({descartar, salto}, fix:evaluar(f(6, 20.1, -99.0), p(5, 19.0, -99.0))),
    ?assertMatch({ok, _}, fix:evaluar(f(8, 20.1, -99.0), p(5, 19.0, -99.0))).  %% 3 pasos: 150 km permitidos
sin_fix_test() ->
    F = (f(6, 0.0, 0.0))#{sats := 0, hdop10 := 99},
    ?assertEqual({ok, sin_fix}, fix:evaluar(F, p(5, 19.0, -99.0))).
