// Núcleo Prolog del laboratorio: toplevel emulado, validador y árbol SLD.
// Se carga en swipl-wasm como /lab.pl (y en swipl nativo para pruebas).
window.LAB_PL = String.raw`
:- module(lab, [lab_solve/3, lab_flush/0, lab_cols/2, lab_check/2, lab_tree/3, lab_chk/1, lab_unload/1]).

% ---------- Toplevel ----------------------------------------------------
% lab_solve(+Src, -Kind, -Out): una solución por backtracking.
% Kind = det | nondet | error.  Falla cuando la consulta falla.
lab_solve(Src, Kind, Out) :-
    catch(term_string(G, Src, [variable_names(Bs)]), E, true),
    (   nonvar(E)
    ->  err_string(E, Out), Kind = error
    ;   catch(call_with_inference_limit(call_cleanup(user:G, Done = true),
                                        20000000, R), E2, true),
        (   nonvar(E2)
        ->  err_string(E2, Out), Kind = error
        ;   R == inference_limit_exceeded
        ->  Out = "ERROR: límite de 20M inferencias (¿recursión infinita?)", Kind = error
        ;   answer(Bs, Out),
            ( Done == true -> Kind = det ; Kind = nondet )
        )
    ).

lab_flush :-
    ( line_position(user_output, P), P > 0 -> nl(user_output) ; true ),
    flush_output(user_output).

err_string(error(F, _), S) :- F \== syntax_error(_), !, err_string2(error(F, _), S).
err_string(E, S) :- err_string2(E, S).
err_string2(E, S) :-
    (   catch('$messages':translate_message(E, Lines, []), _, fail)
    ->  with_output_to(string(S0), print_message_lines(current_output, '', Lines))
    ;   format(string(S0), "~q", [E])
    ),
    split_string(S0, "", "\n", [S1]),
    string_concat("ERROR: ", S1, S).

% Respuesta estilo swipl: "X = a,\nY = b" o "true".
answer(Bs0, Out) :-
    exclude(anon, Bs0, Bs),
    findall(S, ( name_vars(Bs), fmt_bindings(Bs, S) ), [Out]).

anon(N = _) :- sub_atom(N, 0, _, _, '_').

name_vars(Bs) :- name_vars(Bs, []).
name_vars(Bs, Extra) :-
    maplist(bind_name, Bs),
    term_variables(Bs-Extra, Fs),
    name_fresh(Fs, 0).

bval(_ = V, V).
bind_name(N = V) :- ( var(V) -> V = '$VAR'(N) ; true ).

name_fresh([], _).
name_fresh([V|Vs], I) :-
    C is 0'A + I mod 26, K is I // 26,
    ( K =:= 0 -> format(atom(N), "_~c", [C]) ; format(atom(N), "_~c~w", [C, K]) ),
    V = '$VAR'(N), I1 is I + 1, name_fresh(Vs, I1).

fmt_bindings(Bs, S) :-
    findall(L, ( member(N = V, Bs), V \== '$VAR'(N),
                 format(string(L), "~w = ~W", [N, V, [quoted(true), portray(true),
                        numbervars(true), spacing(next_argument)]]) ), Ls),
    ( Ls == [] -> S = "true" ; atomic_list_concat(Ls, ',\n', A), atom_string(A, S) ).

% ---------- Validador ---------------------------------------------------
% lab_cols(+Src, -Cols): columnas (valores ordenados) de cada variable con
% nombre que quede ligada. Sirve para comparar consultas sin importar
% nombres de variables ni orden de las soluciones.
lab_cols(Src, Cols) :-
    term_string(G, Src, [variable_names(Bs0)]),
    exclude(anon, Bs0, Bs),
    maplist(bval, Bs, Vs),
    % límite de inferencias (si no, repeat/recursión infinita cuelgan la página)
    % y salida descartada (si no, write/format se imprimen dos veces)
    % y mensajes silenciados (si no, run_tests/warnings se repiten en la terminal)
    catch(setup_call_cleanup(
              asserta((user:message_hook(_, _, _) :- true), Ref),
              with_output_to(string(_),
                  call_with_inference_limit(findall(Vs, limit(500, user:G), Rows),
                                            5000000, Lim)),
              erase(Ref)), _, fail),
    Lim \== inference_limit_exceeded,
    Rows \== [],
    length(Vs, N),
    findall(Col, ( between(1, N, I),
                   findall(X, ( member(R, Rows), nth1(I, R, X) ), Col0),
                   \+ ( member(X, Col0), var(X) ),
                   sort(Col0, Col) ), Cols).

% lab_check(+UserSrc, +RefSrc): toda columna de la referencia aparece en la
% consulta del alumno.
lab_check(User, Ref) :-
    lab_cols(Ref, RC), lab_cols(User, UC),
    forall(member(C, RC), ( member(U, UC), U =@= C )).

% ---------- Árbol SLD ---------------------------------------------------
% lab_tree(+Src, +MaxSol, -Out): explora el árbol de resolución (Prolog
% puro) y devuelve eventos, uno por línea:
%   node|Id|Padre|Resolvente   dead|Id   sol|Id|Respuesta   limit|Id
:- dynamic ev/1, kid/1.

lab_tree(Src, Max, Out) :-
    retractall(ev(_)), retractall(kid(_)),
    nb_setval(lab_id, 0), nb_setval(lab_sols, 0),
    term_string(G, Src, [variable_names(Bs0)]),
    exclude(anon, Bs0, Bs),
    conj_list(G, Gs),
    catch(( sld(Gs, 0, Bs, Max) -> true ; true ), lab_stop, true),
    findall(L, ev(L), Ls),
    atomic_list_concat(Ls, '\n', A), atom_string(A, Out).

sld(Gs, P, Bs, Max) :-
    nb_getval(lab_id, I0), N is I0 + 1, nb_setval(lab_id, N),
    ( N > 400 -> emit("limit|~w", [P]), throw(lab_stop) ; true ),
    assertz(kid(P)),
    label(Gs, Bs, Lbl), emit("node|~w|~w|~w", [N, P, Lbl]),
    (   Gs == []
    ->  answer(Bs, Ans0), split_string(Ans0, "\n", "", Parts),
        atomic_list_concat(Parts, ' ', Ans),
        emit("sol|~w|~w", [N, Ans]),
        nb_getval(lab_sols, S0), S is S0 + 1, nb_setval(lab_sols, S),
        ( S >= Max -> throw(lab_stop) ; fail )
    ;   Gs = [G|Rest],
        (   step(G, Body), conj_list(Body, Bl), append(Bl, Rest, R),
            sld(R, N, Bs, Max)
        ;   \+ kid(N), emit("dead|~w", [N]), fail
        )
    ).

step(true, true) :- !.
step(G, Body) :-
    (   user_pred(G) -> clause(user:G, Body)
    ;   catch(user:G, E, (print_message(error, E), fail)), Body = true
    ).

user_pred(G) :-
    callable(G), \+ G = (_,_),
    predicate_property(user:G, number_of_clauses(_)),
    \+ predicate_property(user:G, imported_from(_)),
    \+ predicate_property(user:G, built_in).

conj_list(G, L) :- var(G), !, L = [G].
conj_list(true, []) :- !.
conj_list((A, B), L) :- !, conj_list(A, La), conj_list(B, Lb), append(La, Lb, L).
conj_list(G, [G]).

label(Gs, Bs, S) :-
    findall(S0, ( name_vars(Bs, Gs), lbl(Gs, S0) ), [S]).
lbl([], "□") :- !.
lbl(Gs, S) :-
    findall(T, ( member(G, Gs), format(string(T), "~W", [G, [quoted(true),
                 numbervars(true), spacing(next_argument)]]) ), Ts),
    atomic_list_concat(Ts, ', ', A), atom_string(A, S).

emit(F, A) :- format(string(S), F, A), assertz(ev(S)).

% ---------- Utilidades --------------------------------------------------
lab_chk(Src) :-
    term_string(G, Src),
    catch(call_with_inference_limit(user:G, 20000000, R), _, fail),
    R \== inference_limit_exceeded, !.

lab_unload(Base) :-
    atom_concat(Base, '.pl', B),
    forall(( source_file(F), file_base_name(F, B) ), unload_file(F)).
`;
