% =====================================================================
% Programa:    modulos_prolog.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.1 — Desarrollo de programas lógicos
% Fecha:       2026-07-18
% Descripción: Módulos Prolog con firmas explícitas: validador CURP modular
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(validador_curp, [
    validar_curp/2,
    extraer_componentes/2,
    fecha_nacimiento/2,
    estado_valido/1
]).

:- use_module(library(plunit)).

%% ============================================================
%% MÓDULO: validador_curp
%% Valida y analiza CURPs mexicanas (18 caracteres)
%% Estructura: AAAA AAMMDD S EE CCC VV
%%   AAAA = 4 iniciales (apellido1[1], apellido1[vocal], apellido2[1], nombre[1])
%%   AAMMDD = fecha nacimiento (año, mes, día)
%%   S = sexo (H/M)
%%   EE = clave estado (2 letras)
%%   CCC = consonantes internas apellidos+nombre
%%   VV = homoclave + dígito verificador (alfanumérico)
%% ============================================================

%% validar_curp/2 — semidet
%% validar_curp(+CURP:atom, -Resultado:term) is semidet
%% Resultado = ok(Componentes) | error(Razon)
%% Invariante: CURP debe ser átomo. Falla si no es átomo.
validar_curp(CURP, ok(Componentes)) :-
    atom(CURP),
    atom_chars(CURP, Chars),
    length(Chars, 18),
    !,
    extraer_componentes(CURP, Componentes).
validar_curp(CURP, error(longitud_invalida)) :-
    atom(CURP),
    atom_chars(CURP, Chars),
    length(Chars, Len),
    Len \= 18,
    !.
validar_curp(_, error(no_es_atomo)).

%% extraer_componentes/2 — det
%% extraer_componentes(+CURP:atom, -Componentes:dict) is det
%% Precondición: CURP tiene exactamente 18 caracteres
%% Retorna diccionario con todos los campos de la CURP
extraer_componentes(CURP, componentes{
    iniciales: Iniciales,
    fecha: Fecha,
    sexo: Sexo,
    estado: Estado,
    consonantes: Consonantes,
    verificacion: Verificacion
}) :-
    atom_chars(CURP, Chars),
    length(Chars, 18),
    % Extraer cada campo por posición
    extraer_rango(Chars, 0, 4, InicialesChars),
    extraer_rango(Chars, 4, 6, FechaChars),
    extraer_rango(Chars, 10, 1, [SexoChar]),
    extraer_rango(Chars, 11, 2, EstadoChars),
    extraer_rango(Chars, 13, 3, ConsonantesChars),
    extraer_rango(Chars, 16, 2, VerificacionChars),
    % Convertir a átomos
    atom_chars(Iniciales, InicialesChars),
    atom_chars(Fecha, FechaChars),
    atom_chars(Sexo, [SexoChar]),
    atom_chars(Estado, EstadoChars),
    atom_chars(Consonantes, ConsonantesChars),
    atom_chars(Verificacion, VerificacionChars).

%% extraer_rango/4 — det (auxiliar privado)
%% extraer_rango(+Lista, +Inicio, +Longitud, -Sublista) is det
extraer_rango(Lista, Inicio, Long, Sub) :-
    length(Prefijo, Inicio),
    append(Prefijo, Resto, Lista),
    length(Sub, Long),
    append(Sub, _, Resto).

%% fecha_nacimiento/2 — semidet
%% fecha_nacimiento(+CURP:atom, -Fecha:term) is semidet
%% Fecha = fecha(Año:integer, Mes:integer, Dia:integer)
%% Falla si la fecha en la CURP no es válida (mes 1-12, día 1-31)
fecha_nacimiento(CURP, fecha(Año, Mes, Dia)) :-
    atom_chars(CURP, Chars),
    length(Chars, 18),
    extraer_rango(Chars, 4, 2, AñoChars),
    extraer_rango(Chars, 6, 2, MesChars),
    extraer_rango(Chars, 8, 2, DiaChars),
    number_chars(AñoCorto, AñoChars),
    number_chars(Mes, MesChars),
    number_chars(Dia, DiaChars),
    % Validar rangos
    Mes >= 1, Mes =< 12,
    Dia >= 1, Dia =< 31,
    % Heurística de siglo: >= 25 → 1900s, < 25 → 2000s
    (AñoCorto >= 25 -> Año is 1900 + AñoCorto ; Año is 2000 + AñoCorto).

%% estado_valido/1 — semidet
%% estado_valido(+Clave:atom) is semidet
%% Verifica que la clave corresponde a un estado mexicano
estado_valido('AS'). % Aguascalientes
estado_valido('BC'). % Baja California
estado_valido('BS'). % Baja California Sur
estado_valido('CC'). % Campeche
estado_valido('CL'). % Coahuila
estado_valido('CM'). % Colima
estado_valido('CS'). % Chiapas
estado_valido('CH'). % Chihuahua
estado_valido('DF'). % Ciudad de México (histórico)
estado_valido('CD'). % Ciudad de México (actual)
estado_valido('DG'). % Durango
estado_valido('GT'). % Guanajuato
estado_valido('GR'). % Guerrero
estado_valido('HG'). % Hidalgo
estado_valido('JC'). % Jalisco
estado_valido('MC'). % Estado de México
estado_valido('MN'). % Michoacán
estado_valido('MS'). % Morelos
estado_valido('NT'). % Nayarit
estado_valido('NL'). % Nuevo León
estado_valido('OC'). % Oaxaca
estado_valido('PL'). % Puebla
estado_valido('QT'). % Querétaro
estado_valido('QR'). % Quintana Roo
estado_valido('SP'). % San Luis Potosí
estado_valido('SL'). % Sinaloa
estado_valido('SR'). % Sonora
estado_valido('TC'). % Tabasco
estado_valido('TS'). % Tamaulipas
estado_valido('TL'). % Tlaxcala
estado_valido('VZ'). % Veracruz
estado_valido('YN'). % Yucatán
estado_valido('ZS'). % Zacatecas
estado_valido('NE'). % Nacido en el extranjero

%% ============================================================
%% TESTS — ejecutar con: ?- run_tests(validador_curp).
%% ============================================================

:- begin_tests(validador_curp).

% CURP válida — Ejemplo ficticio pero con estructura correcta
test(curp_valida_estructura, [nondet]) :-
    validar_curp('GASA850101HBCRRN09', ok(_)).

% CURP demasiado corta
test(curp_muy_corta) :-
    validar_curp('GASA850101', error(longitud_invalida)).

% CURP demasiado larga
test(curp_muy_larga) :-
    validar_curp('GASA850101HBCRRN09XX', error(longitud_invalida)).

% No es átomo — debe fallar o retornar error
test(no_es_atomo) :-
    validar_curp(12345, error(no_es_atomo)).

% Extracción de componentes
test(extraer_iniciales, [nondet]) :-
    extraer_componentes('GASA850101HBCRRN09', C),
    C.iniciales == 'GASA'.

test(extraer_estado, [nondet]) :-
    extraer_componentes('GASA850101HBCRRN09', C),
    C.estado == 'BC'.

test(extraer_sexo, [nondet]) :-
    extraer_componentes('GASA850101HBCRRN09', C),
    C.sexo == 'H'.

% Fecha de nacimiento
test(fecha_valida) :-
    fecha_nacimiento('GASA850101HBCRRN09', fecha(1985, 1, 1)).

% Estado válido
test(estado_bc) :- estado_valido('BC').
test(estado_mx) :- estado_valido('MC').
test(estado_invalido, [fail]) :- estado_valido('XX').

:- end_tests(validador_curp).

%% ============================================================
%% EJECUCIÓN DIRECTA
%% swipl -g "run_tests(validador_curp), halt" -l modulos_prolog.pl
%% ============================================================
