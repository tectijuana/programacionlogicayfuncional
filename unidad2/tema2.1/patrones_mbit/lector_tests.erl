-module(lector_tests).
-include_lib("eunit/include/eunit.hrl").

leer_test_() ->
    [?_assertEqual({temp, 24},            lector:leer(<<"T:24\r">>)),
     ?_assertEqual({temp, -3},            lector:leer(<<"T:-3">>)),
     ?_assertEqual({boton, a},            lector:leer(<<"B:A\r">>)),
     ?_assertEqual({boton, ab},           lector:leer(<<"B:AB">>)),
     ?_assertEqual({acc, 12, -40, 1010},  lector:leer(<<"A:12,-40,1010\r">>)),
     ?_assertEqual(basura, lector:leer(<<"T:cuarenta">>)),
     ?_assertEqual(basura, lector:leer(<<"A:1,2">>)),
     ?_assertEqual(basura, lector:leer(<<"A:1,2,3,4">>)),
     ?_assertEqual(basura, lector:leer(<<"B:C">>)),
     ?_assertEqual(basura, lector:leer(<<255, 254, "x">>)),
     ?_assertEqual(basura, lector:leer(<<>>))].

clasificar_test_() ->
    [?_assertEqual(alerta, lector:clasificar({temp, 40})),
     ?_assertEqual(normal, lector:clasificar({temp, 39})),
     ?_assertEqual(alerta, lector:clasificar({acc, 1500, 900, 1600})),
     ?_assertEqual(normal, lector:clasificar({acc, 0, 0, 1024})),
     ?_assertEqual(ignorar, lector:clasificar(basura))].

%% Lo que NO esta cubierto por ninguna clausula revienta en tiempo de ejecucion:
sin_clausula_test() ->
    ?assertError(function_clause, lector:clasificar({temperatura, 20})).
