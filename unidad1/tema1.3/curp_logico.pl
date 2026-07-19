% =====================================================================
% Programa:    curp_logico.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 1.3 — Comparación de paradigmas
% Fecha:       2026-07-18
% Descripción: Validador de CURP en paradigma lógico declarativo
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% Archivo: curp_logico.pl
%% Validador de CURP mexicana usando programación lógica pura (SWI-Prolog)
%%
%% Estructura CURP (18 caracteres):
%%   Pos  1- 4: 4 letras del apellido/nombre
%%   Pos  5- 6: AA año de nacimiento (00-99)
%%   Pos  7- 8: MM mes  (01-12)
%%   Pos  9-10: DD día  (01-31)
%%   Pos 11   : H o M  (sexo)
%%   Pos 12-13: clave de estado (BC, DF, ...)
%%   Pos 14-16: 3 consonantes internas de apellido
%%   Pos 17-18: 2 caracteres alfanuméricos de verificación
%%
%% Ejecutar:
%%   swipl -g "validar_curp('ROSO850312HBCNLS09', R), write(R), nl, halt" -l curp_logico.pl
%%   swipl -g "run_tests, halt" -l curp_logico.pl

:- module(curp_logico, [validar_curp/2, extraer_fecha/2, estado_valido/1, sexo_valido/1]).
:- use_module(library(plunit)).

%% ============================================================
%% HECHOS: claves de estados mexicanos
%% estado_valido/1 — det
%% estado_valido(+Clave:atom) is det
%% ============================================================

estado_valido('AS').  % Aguascalientes
estado_valido('BC').  % Baja California
estado_valido('BS').  % Baja California Sur
estado_valido('CM').  % Campeche
estado_valido('CS').  % Chiapas
estado_valido('CH').  % Chihuahua
estado_valido('CL').  % Coahuila
estado_valido('CO').  % Colima
estado_valido('DF').  % Ciudad de México (antes D.F.)
estado_valido('DG').  % Durango
estado_valido('GT').  % Guanajuato
estado_valido('GR').  % Guerrero
estado_valido('HG').  % Hidalgo
estado_valido('JC').  % Jalisco
estado_valido('MC').  % Estado de México
estado_valido('MN').  % Michoacán
estado_valido('MS').  % Morelos
estado_valido('NT').  % Nayarit
estado_valido('NL').  % Nuevo León
estado_valido('OC').  % Oaxaca
estado_valido('PL').  % Puebla
estado_valido('QT').  % Querétaro
estado_valido('QR').  % Quintana Roo
estado_valido('SP').  % San Luis Potosí
estado_valido('SL').  % Sinaloa
estado_valido('SR').  % Sonora
estado_valido('TC').  % Tabasco
estado_valido('TS').  % Tamaulipas
estado_valido('TL').  % Tlaxcala
estado_valido('VZ').  % Veracruz
estado_valido('YN').  % Yucatán
estado_valido('ZS').  % Zacatecas
estado_valido('NE').  % Nacido en el Extranjero

%% ============================================================
%% sexo_valido/1 — det
%% sexo_valido(+Char:atom) is det
%% ============================================================

sexo_valido('H').  % Hombre
sexo_valido('M').  % Mujer

%% ============================================================
%% extraer_fecha/2 — det
%% extraer_fecha(+CURP:atom, -Fecha:term) is semidet
%% Extrae fecha(Anno, Mes, Dia) de la CURP y valida rangos.
%% Anno es el año de 2 dígitos (00-99); el siglo se infiere fuera de este módulo.
%% ============================================================

extraer_fecha(CURP, fecha(Anno, Mes, Dia)) :-
    atom_string(CURP, S),
    string_length(S, 18),
    sub_string(S, 4, 2, _, AnnoStr),
    sub_string(S, 6, 2, _, MesStr),
    sub_string(S, 8, 2, _, DiaStr),
    number_string(Anno, AnnoStr),
    number_string(Mes,  MesStr),
    number_string(Dia,  DiaStr),
    Anno >= 0, Anno =< 99,
    Mes  >= 1, Mes  =< 12,
    Dia  >= 1, Dia  =< 31.

%% ============================================================
%% validar_curp/2 — semidet
%% validar_curp(+CURP:atom, -Resultado:term) is semidet
%% Retorna ok(Datos) si la CURP pasa todas las validaciones,
%% o error(Razon) con el motivo del primer fallo encontrado.
%% ============================================================

validar_curp(CURP, Resultado) :-
    atom_string(CURP, S),
    ( string_length(S, 18)
    -> validar_estructura(S, Resultado)
    ;  Resultado = error(longitud_invalida)
    ).

%% validar_estructura/2 — det (una vez que la longitud es correcta)
validar_estructura(S, Resultado) :-
    % Extraer componentes
    sub_string(S,  0, 4, _, NombreStr),
    sub_string(S,  4, 2, _, AnnoStr),
    sub_string(S,  6, 2, _, MesStr),
    sub_string(S,  8, 2, _, DiaStr),
    sub_string(S, 10, 1, _, SexoStr),
    sub_string(S, 11, 2, _, EstadoStr),
    sub_string(S, 13, 3, _, ConsonantesStr),
    sub_string(S, 16, 2, _, VerificacionStr),

    % Convertir a átomos para comparar con hechos
    atom_string(SexoAtom,   SexoStr),
    atom_string(EstadoAtom, EstadoStr),

    % Validar sexo
    ( sexo_valido(SexoAtom)
    -> true
    ;  Resultado = error(sexo_invalido(SexoStr)), !
    ),

    % Validar estado
    ( estado_valido(EstadoAtom)
    -> true
    ;  Resultado = error(estado_invalido(EstadoStr)), !
    ),

    % Validar fecha
    ( number_string(Anno, AnnoStr),
      number_string(Mes,  MesStr),
      number_string(Dia,  DiaStr),
      Anno >= 0, Anno =< 99,
      Mes  >= 1, Mes  =< 12,
      Dia  >= 1, Dia  =< 31
    -> true
    ;  Resultado = error(fecha_invalida(AnnoStr, MesStr, DiaStr)), !
    ),

    % Todo correcto — empaquetar datos extraídos
    ( var(Resultado)
    -> number_string(Anno2, AnnoStr),
       number_string(Mes2,  MesStr),
       number_string(Dia2,  DiaStr),
       Resultado = ok(curp_datos{
           nombre:       NombreStr,
           fecha:        fecha(Anno2, Mes2, Dia2),
           sexo:         SexoAtom,
           estado:       EstadoAtom,
           consonantes:  ConsonantesStr,
           verificacion: VerificacionStr
       })
    ; true
    ).

%% ============================================================
%% DEMO: mostrar resultado de validar una CURP
%% demo/0 — det
%% ============================================================

demo :-
    Ejemplos = [
        'ROSO850312HBCNLS09',   % válida (ficticia)
        'GALE920710MBCSRN05',   % válida (ficticia)
        'CURP_CORTA',           % inválida: longitud
        'ROSO850312XBCNLS09',   % inválida: sexo
        'ROSO850312HXX NLS09'   % inválida: estado
    ],
    forall(member(CURP, Ejemplos),
           ( validar_curp(CURP, R),
             format("CURP: ~w~n  => ~w~n~n", [CURP, R])
           )).

%% ============================================================
%% TESTS con plunit
%% Ejecutar: swipl -g "run_tests, halt" -l curp_logico.pl
%% ============================================================

:- begin_tests(validador_curp).

test(longitud_correcta) :-
    validar_curp('ROSO850312HBCNLS09', ok(_)).

test(longitud_incorrecta) :-
    validar_curp('CORTA', error(longitud_invalida)).

test(sexo_hombre) :-
    validar_curp('ROSO850312HBCNLS09', R),
    R = ok(D),
    get_dict(sexo, D, 'H').

test(sexo_mujer) :-
    validar_curp('GALE920710MBCSRN05', R),
    R = ok(D),
    get_dict(sexo, D, 'M').

test(estado_extranjero) :-
    estado_valido('NE').

test(estado_baja_california) :-
    estado_valido('BC').

test(fecha_extraida) :-
    extraer_fecha('ROSO850312HBCNLS09', fecha(85, 3, 12)).

test(mes_invalido, fail) :-
    % Mes 13 no existe — extraer_fecha debe fallar
    extraer_fecha('ROSO851312HBCNLS09', _).

:- end_tests(validador_curp).
