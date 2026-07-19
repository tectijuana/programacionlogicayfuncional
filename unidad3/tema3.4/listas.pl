% =====================================================================
% Programa:    listas.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.4 — Introducción a Prolog
% Fecha:       2026-07-18
% Descripción: Listas desde cero: mi_member, mi_append, mi_flatten… (28 tests plunit)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% listas.pl — Implementación propia de predicados de listas en SWI-Prolog
%% TecNM — Programación Lógica y Funcional, Unidad 3 Tema 3.4
%%
%% REGLA: No usar predicados de biblioteca (member, append, length, etc.)
%% Todo implementado desde cero usando recursión y pattern matching.
%%
%% Ejecutar tests: swipl -g "run_tests(listas), halt" -l listas.pl
%% Interactivo:    swipl -l listas.pl

:- use_module(library(plunit)).

%% ============================================================
%% mi_member/2 — nondet
%% mi_member(?Elem, +Lista) — Elem es miembro de Lista
%%
%% Ejemplos:
%% ?- mi_member(2, [1,2,3]).       → true ; false
%% ?- mi_member(X, [a,b,c]).       → X=a ; X=b ; X=c ; false
%% ?- mi_member(5, [1,2,3]).       → false
%% ============================================================
mi_member(X, [X|_]).
mi_member(X, [_|T]) :- mi_member(X, T).

%% ============================================================
%% mi_append/3 — nondet en modo (?,?,+), det en modo (+,+,-)
%% mi_append(?Lista1, ?Lista2, ?Total) — Total = Lista1 ++ Lista2
%%
%% Ejemplos:
%% ?- mi_append([1,2], [3,4], R).  → R=[1,2,3,4]
%% ?- mi_append(X, Y, [1,2,3]).    → X=[], Y=[1,2,3] ; X=[1], Y=[2,3] ; ...
%% ?- mi_append([1], [2,3], [1,2,3]).  → true
%% ============================================================
mi_append([], L, L).
mi_append([H|T], L, [H|R]) :- mi_append(T, L, R).

%% ============================================================
%% mi_length/2 — det
%% mi_length(+Lista, -N) — N es la longitud de Lista
%% Implementación con acumulador (tail recursive)
%%
%% Ejemplos:
%% ?- mi_length([a,b,c], N).       → N=3
%% ?- mi_length([], N).             → N=0
%% ?- mi_length([1,[2,3],4], N).   → N=3 (lista anidada cuenta como 1 elemento)
%% ============================================================
mi_length(Lista, N) :- mi_length(Lista, 0, N).

%% mi_length/3 — det (auxiliar con acumulador)
mi_length([], Acc, Acc).
mi_length([_|T], Acc, N) :-
    Acc1 is Acc + 1,
    mi_length(T, Acc1, N).

%% ============================================================
%% mi_reverse/2 — det
%% mi_reverse(+Lista, -Invertida) — Invertida es Lista al revés
%% Implementación con acumulador (tail recursive)
%%
%% Ejemplos:
%% ?- mi_reverse([1,2,3], R).      → R=[3,2,1]
%% ?- mi_reverse([], R).            → R=[]
%% ?- mi_reverse([solo], R).       → R=[solo]
%% ============================================================
mi_reverse(Lista, Invertida) :- mi_reverse(Lista, [], Invertida).

%% mi_reverse/3 — det (auxiliar con acumulador)
mi_reverse([], Acc, Acc).
mi_reverse([H|T], Acc, Inv) :- mi_reverse(T, [H|Acc], Inv).

%% ============================================================
%% mi_nth0/3 — det
%% mi_nth0(+Indice, +Lista, -Elem) — Elem está en posición Indice (base 0)
%%
%% Ejemplos:
%% ?- mi_nth0(0, [a,b,c], E).      → E=a
%% ?- mi_nth0(2, [a,b,c], E).      → E=c
%% ?- mi_nth0(5, [a,b,c], _).      → false (índice fuera de rango)
%% ============================================================
mi_nth0(0, [H|_], H) :- !.
mi_nth0(N, [_|T], E) :-
    N > 0,
    N1 is N - 1,
    mi_nth0(N1, T, E).

%% ============================================================
%% mi_last/2 — semidet
%% mi_last(+Lista, -Ultimo) — Ultimo es el último elemento de Lista
%% Falla si Lista está vacía
%%
%% Ejemplos:
%% ?- mi_last([1,2,3], L).         → L=3
%% ?- mi_last([solo], L).          → L=solo
%% ?- mi_last([], _).              → false
%% ============================================================
mi_last([X], X) :- !.
mi_last([_|T], X) :- mi_last(T, X).

%% ============================================================
%% mi_flatten/2 — det
%% mi_flatten(+ListaAnidada, -ListaPlana) — aplana listas anidadas
%%
%% Ejemplos:
%% ?- mi_flatten([1,[2,3],[4,[5,6]]], F).  → F=[1,2,3,4,5,6]
%% ?- mi_flatten([a,[],[b,c]], F).          → F=[a,b,c]
%% ?- mi_flatten([], F).                    → F=[]
%% ============================================================
mi_flatten([], []).
mi_flatten([H|T], Plana) :-
    is_list(H), !,
    mi_flatten(H, PH),
    mi_flatten(T, PT),
    mi_append(PH, PT, Plana).
mi_flatten([H|T], [H|PT]) :-
    mi_flatten(T, PT).

%% ============================================================
%% mi_max_list/2 — det
%% mi_max_list(+Lista, -Max) — Max es el mayor elemento numérico
%% Falla si Lista está vacía
%%
%% Ejemplos:
%% ?- mi_max_list([3,1,4,1,5,9,2,6], M).  → M=9
%% ?- mi_max_list([42], M).                → M=42
%% ?- mi_max_list([], _).                  → false
%% ============================================================
mi_max_list([X], X).
mi_max_list([H|T], Max) :-
    mi_max_list(T, MaxT),
    Max is max(H, MaxT).

%% ============================================================
%% mi_sum_list/2 — det
%% mi_sum_list(+Lista, -Suma) — Suma es la suma de elementos numéricos
%% Retorna 0 para lista vacía
%%
%% Ejemplos:
%% ?- mi_sum_list([1,2,3,4,5], S).         → S=15
%% ?- mi_sum_list([], S).                   → S=0
%% ?- mi_sum_list([10.5, 2.5], S).         → S=13.0
%% ============================================================
mi_sum_list(Lista, Suma) :- mi_sum_list(Lista, 0, Suma).

mi_sum_list([], Acc, Acc).
mi_sum_list([H|T], Acc, Suma) :-
    Acc1 is Acc + H,
    mi_sum_list(T, Acc1, Suma).

%% ============================================================
%% Tests con plunit
%% ============================================================

:- begin_tests(listas).

% mi_member
test(member_encontrado, [nondet]) :- mi_member(2, [1,2,3]).
test(member_primero, [nondet])    :- mi_member(1, [1,2,3]).
test(member_ultimo, [nondet])     :- mi_member(3, [1,2,3]).
test(member_no_esta, [fail]) :- mi_member(5, [1,2,3]).
test(member_genera_todos) :-
    findall(X, mi_member(X, [a,b,c]), Xs),
    Xs == [a,b,c].

% mi_append
test(append_dos_listas) :-
    mi_append([1,2], [3,4], R), R == [1,2,3,4].
test(append_vacia_izq) :-
    mi_append([], [1,2], R), R == [1,2].
test(append_vacia_der) :-
    mi_append([1,2], [], R), R == [1,2].
test(append_particiones) :-
    findall(X-Y, mi_append(X, Y, [1,2]), Ps),
    length(Ps, 3).  % [], [1], [1,2]

% mi_length
test(length_tres) :- mi_length([a,b,c], 3).
test(length_vacia) :- mi_length([], 0).
test(length_uno)   :- mi_length([x], 1).

% mi_reverse
test(reverse_normal) :-
    mi_reverse([1,2,3], R), R == [3,2,1].
test(reverse_vacia) :-
    mi_reverse([], R), R == [].
test(reverse_palindromo) :-
    mi_reverse([1,2,1], R), R == [1,2,1].

% mi_nth0
test(nth0_primero)  :- mi_nth0(0, [a,b,c], a).
test(nth0_ultimo)   :- mi_nth0(2, [a,b,c], c).
test(nth0_fuera, [fail]) :- mi_nth0(5, [a,b,c], _).

% mi_last
test(last_normal) :- mi_last([1,2,3], 3).
test(last_uno)    :- mi_last([x], x).
test(last_vacia, [fail]) :- mi_last([], _).

% mi_flatten
test(flatten_anidada) :-
    mi_flatten([1,[2,3],[4,[5,6]]], F),
    F == [1,2,3,4,5,6].
test(flatten_vacia) :-
    mi_flatten([], F), F == [].

% mi_max_list
test(max_lista, [nondet]) :- mi_max_list([3,1,9,2,6], 9).
test(max_uno, [nondet]) :- mi_max_list([42], 42).
test(max_vacia, [fail]) :- mi_max_list([], _).

% mi_sum_list
test(sum_normal) :- mi_sum_list([1,2,3,4,5], 15).
test(sum_vacia)  :- mi_sum_list([], 0).

:- end_tests(listas).
