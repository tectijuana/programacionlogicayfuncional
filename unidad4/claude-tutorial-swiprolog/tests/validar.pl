% validar.pl — valida una lección con swipl nativo y el módulo lab de la página.
% Uso (lo invoca validar_lecciones.mjs):  swipl validar.pl lab.pl casos.pl
% casos.pl define el módulo casos con:
%   archivo(Ruta).  programa(Texto).  demo(Src).  arbol(Src, Max).
%   reto(I, query, Ref, Sol).  reto(I, program, Check, Sol).
:- initialization(main, main).
:- dynamic v_aviso/1, v_fallas/1.
v_fallas(0).

user:message_hook(Term, Kind, _) :-
    memberchk(Kind, [warning, error]), nb_current(cargando, true),
    message_to_codes(Term, Kind, S), assertz(v_aviso(S)), fail.

message_to_codes(Term, Kind, S) :-
    catch(( '$messages':translate_message(Term, Ls, []),
            with_output_to(string(S0), print_message_lines(current_output, '', Ls)),
            format(string(S), "~w: ~s", [Kind, S0]) ), _, format(string(S), "~w: ~q", [Kind, Term])).

v_falla(F, A) :-
    format("  FALLA: "), format(F, A), nl,
    retract(v_fallas(N)), N1 is N + 1, assertz(v_fallas(N1)).

v_cargar(Texto) :-
    casos:archivo(F),
    setup_call_cleanup(open(F, write, O), write(O, Texto), close(O)),
    retractall(v_aviso(_)),
    nb_setval(cargando, true),
    consult(F),
    nb_setval(cargando, false),
    forall(v_aviso(S), v_falla("al consultar: ~s", [S])).

main :-
    current_prolog_flag(argv, [Lab, Casos]),
    use_module(Lab),
    load_files(Casos, []),
    casos:programa(P0),
    v_paso(carga, v_cargar(P0)),
    v_paso(demo, forall(casos:demo(Q), v_demo_ok(Q))),
    v_paso(arbol, forall(casos:arbol(Q, M),
        ( catch(lab:lab_tree(Q, M, _), _, fail) -> true ; v_falla("árbol ~s", [Q]) ))),
    v_paso(referencias, forall(casos:reto(I, query, Ref, _), v_ref_ok(I, Ref))),
    v_paso(cruces, forall(( casos:reto(I, query, _, SolI), casos:reto(J, query, RefJ, _), I \== J,
                          v_usa_ok(J, SolI) ),
        ( lab:lab_check(SolI, RefJ) -> v_falla("la solución del reto ~w también aprueba el reto ~w", [I, J]) ; true ))),
    nb_setval(prog, P0),
    v_paso(retos, forall(casos:reto(I, T, X, Sol), v_reto_ok(I, T, X, Sol))),
    v_fallas(N),
    ( N =:= 0 -> halt(0) ; halt(1) ).

% v_paso(Nombre, Meta): ejecuta una fase y reporta excepción o fallo
v_paso(N, G) :-
    (   catch(G, E, (v_falla("fase ~w: ~q", [N, E]), fail)) -> true
    ;   v_fallas(_), v_falla("fase ~w falló", [N])
    ).

% v_demo_ok(Q): la consulta de la demo no termina en error (false es válido)
v_demo_ok(Q) :-
    (   lab:lab_solve(Q, K, O)
    ->  ( K == error -> v_falla("demo ~s -> ~s", [Q, O]) ; true )
    ;   format("  nota: demo ~s -> false~n", [Q])
    ).

% v_ref_ok(I, Ref): la referencia tiene soluciones y liga alguna variable
v_ref_ok(I, Ref) :-
    (   lab:lab_cols(Ref, Cs)
    ->  (   Cs == [], \+ sub_string(Ref, _, _, _, "run_tests")
        ->  v_falla("reto ~w: la referencia no liga variables (aprobaría cualquier cosa)", [I])
        ;   true )
    ;   v_falla("reto ~w: la referencia ~s no tiene soluciones", [I, Ref])
    ).

% v_reto_ok(I, Tipo, RefOCheck, Sol): resolver el reto como lo haría un alumno
v_reto_ok(I, query, Ref, Sol) :-
    ( lab:lab_check(Sol, Ref) -> true ; v_falla("reto ~w: la solución ~s no aprueba", [I, Sol]) ).
v_reto_ok(I, program, Check, Sol) :-
    ( lab:lab_chk(Check) -> v_falla("reto ~w: el check ya pasa sin resolver el reto", [I]) ; true ),
    nb_getval(prog, P1),
    format(string(P2), "~s~n~n~s~n", [P1, Sol]),
    nb_setval(prog, P2),
    v_cargar(P2),
    ( lab:lab_chk(Check) -> true ; v_falla("reto ~w: el check ~s no pasa con la solución", [I, Check]) ).

% v_usa_ok(J, Src): Src menciona los átomos `usa` del reto J (como en app.js)
v_usa_ok(J, Src) :-
    ( casos:usa(J, As) -> true ; As = [] ),
    forall(member(A, As), sub_string(Src, _, _, _, A)).
