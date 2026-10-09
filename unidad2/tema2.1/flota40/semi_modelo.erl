%% semi_modelo: NUCLEO PURO de un semi (sin procesos, sin sockets, sin azar, sin reloj).
%% "Functional core, imperative shell": toda la logica de estados y GPS vive aqui como
%% funciones puras y totales; semi.erl (el shell) solo aporta tiempo, azar y UDP.
%% Por ser puro se prueba con eunit sin levantar nada (semi_modelo_tests.erl).
-module(semi_modelo).
-export([nuevo/3, boton/2, orden/2, paso/2, posicion/1, velocidad/2, estado/1, invertir/1]).
-export_type([t/0, estado/0]).

-type estado() :: rodando | detenido | sos.
-type punto()  :: {float(), float()}.
-opaque t() :: #{orig := punto(), dest := punto(), p := float(), estado := estado()}.

%% P0 en [0.0, 1.0]: avance inicial sobre la ruta.
-spec nuevo(punto(), punto(), float()) -> t().
nuevo(Orig, Dest, P0) -> #{orig => Orig, dest => Dest, p => P0, estado => rodando}.

-spec estado(t()) -> estado().
estado(#{estado := E}) -> E.

%% Botones del micro:bit: a = parada/reanudar, b = SOS, logo = dar la vuelta.
-spec boton(a | b | logo, t()) -> t().
boton(a, M = #{estado := rodando})  -> M#{estado := detenido};
boton(a, M = #{estado := detenido}) -> M#{estado := rodando};
boton(a, M)                         -> M;                      %% en SOS, A no hace nada
boton(b, M = #{estado := sos})      -> M#{estado := rodando};
boton(b, M)                         -> M#{estado := sos};
boton(logo, M)                      -> invertir(M).

%% Ordenes de la central. Total: cualquier orden desconocida deja el modelo igual.
-spec orden(binary(), t()) -> t().
orden(<<"detener">>, M = #{estado := rodando})  -> M#{estado := detenido};
orden(<<"reanudar">>, M = #{estado := detenido}) -> M#{estado := rodando};
orden(_, M) -> M.

%% Avanza Delta (fraccion de ruta) solo si esta rodando; al llegar, regresa.
-spec paso(float(), t()) -> t().
paso(_, M = #{estado := E}) when E =/= rodando -> M;
paso(_, M = #{p := P}) when P >= 1.0 -> (invertir(M))#{p := 0.0};
paso(Delta, M = #{p := P}) -> M#{p := P + Delta}.

-spec invertir(t()) -> t().
invertir(M = #{orig := O, dest := D, p := P}) -> M#{orig := D, dest := O, p := 1.0 - P}.

-spec posicion(t()) -> punto().
posicion(#{orig := {La1, Lo1}, dest := {La2, Lo2}, p := P}) ->
    {La1 + (La2 - La1) * P, Lo1 + (Lo2 - Lo1) * P}.

%% R en 0..29 viene del shell (el azar es un efecto, no vive en el nucleo).
-spec velocidad(t(), 0..29) -> non_neg_integer().
velocidad(#{estado := rodando}, R) -> 71 + R;
velocidad(_, _) -> 0.
