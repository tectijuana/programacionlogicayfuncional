:- use_module(validador_imss).
:- use_module(restricciones).
:- use_module(library(plunit)).

:- begin_tests(imss).

% ── vigencia ────────────────────────────────────────────────
test(vigencia_activa_ok) :-
    vigencia_activa('12345678901').

test(vigencia_inactiva_falla, [fail]) :-
    vigencia_activa('34567890123').

% ── atención médica ─────────────────────────────────────────
test(atencion_medica_vigente) :-
    puede_tramitar('12345678901', atencion_medica, ok).

test(atencion_medica_sin_vigencia) :-
    puede_tramitar('34567890123', atencion_medica, error(vigencia_inactiva)).

% ── incapacidad temporal ─────────────────────────────────────
test(incapacidad_suficientes_semanas) :-
    puede_tramitar('12345678901', incapacidad_temporal, ok).

test(incapacidad_pocas_semanas) :-
    puede_tramitar('34567890123', incapacidad_temporal, error(vigencia_inactiva)).

test(incapacidad_vigente_pero_pocas_semanas) :-
    puede_tramitar('23456789012', incapacidad_temporal, ok).

% ── pensión por invalidez ────────────────────────────────────
test(pension_cumple_todo) :-
    puede_tramitar('78901234567', pension_invalidez, ok).

test(pension_sin_dictamen) :-
    puede_tramitar('45678901234', pension_invalidez, error(sin_dictamen_medico)).

test(pension_pocas_semanas) :-
    puede_tramitar('23456789012', pension_invalidez,
                   error(semanas_insuficientes(38, minimo_150))).

% ── guarderías ──────────────────────────────────────────────
test(guarderias_con_hijo) :-
    puede_tramitar('12345678901', guarderias, ok).

test(guarderias_sin_hijo) :-
    puede_tramitar('67890123456', guarderias, error(sin_hijo_registrado)).

% ── préstamo IMSS ────────────────────────────────────────────
test(prestamo_cumple_requisitos) :-
    puede_tramitar('67890123456', prestamo_imss, ok).

test(prestamo_con_adeudo) :-
    puede_tramitar('34567890123', prestamo_imss, error(vigencia_inactiva)).

test(prestamo_pocas_semanas) :-
    puede_tramitar('23456789012', prestamo_imss,
                   error(semanas_insuficientes(38, minimo_52))).

% ── restricciones CLP(FD) ────────────────────────────────────
test(semanas_validas_rango) :-
    semanas_validas(S), S in 0..2080.

test(monto_prestamo_calculado) :-
    monto_prestamo(52, Monto),
    Monto =:= 5200.

test(semanas_para_pension_calcula) :-
    semanas_para_pension(38, Faltan),
    Faltan =:= 112.

test(semanas_para_pension_cero) :-
    semanas_para_pension(200, Faltan),
    Faltan =:= 0.

:- end_tests(imss).
