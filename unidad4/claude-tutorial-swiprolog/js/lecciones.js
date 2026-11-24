// Lecciones (niveles 1–20; 18–20 marcadas local: true).
// demo: pasos del reproductor
//   {c}  comentario narrado      {consult}  carga el programa del editor
//   {q, more}  consulta (+ n veces ';')    {tree, max}  árbol SLD animado
// retos: {tipo:'query', ref} compara soluciones con la consulta de referencia
//        usa: átomos que la consulta debe mencionar (opcional)
//        {tipo:'program', check} meta que debe cumplirse tras consultar
window.LECCIONES = [
{
  id: '1', nivel: 1, titulo: 'Hechos y consultas', tema: 'La familia',
  fuente: 'Bratko, Prolog Programming for AI, cap. 1',
  archivo: 'familia',
  teoria: `
<p>Un programa Prolog es una <b>base de conocimiento</b>. No dices <i>cómo</i> calcular: declaras <i>qué</i> es verdad.</p>
<p>Un <b>hecho</b> es una relación verdadera: <code>padre(juan, ana).</code> Los átomos van en minúscula; termina con punto.</p>
<p>Una <b>consulta</b> pregunta al sistema: <code>?- padre(juan, ana).</code> responde <code>true</code> o <code>false</code>.</p>
<p>Una <b>variable</b> empieza con mayúscula: <code>?- padre(juan, X).</code> Prolog busca valores de <code>X</code>. Con <kbd>;</kbd> pides la siguiente solución.</p>
<p>La coma <code>,</code> es el <b>Y lógico</b>: <code>?- padre(P, luis), madre(M, luis).</code></p>`,
  programa:
`% familia.pl — Base de hechos (Bratko, cap. 1)
% padre(P, H): P es padre de H.
% madre(M, H): M es madre de H.

padre(juan, pedro).
padre(juan, ana).
padre(pedro, luis).
padre(pedro, sofia).
padre(jorge, carmen).

madre(maria, pedro).
madre(maria, ana).
madre(lucia, luis).
madre(lucia, sofia).
madre(ana, carmen).
`,
  demo: [
    { c: 'Bienvenido a Prolog Lab. Este es el shell de SWI-Prolog real, compilado a WebAssembly.' },
    { c: 'Primero cargamos (consultamos) el programa familia.pl:' },
    { consult: true },
    { c: 'Consulta sí/no: ¿juan es padre de ana?' },
    { q: 'padre(juan, ana).' },
    { q: 'padre(ana, juan).' },
    { c: 'Con una variable, Prolog busca valores que hagan verdadera la consulta.' },
    { c: 'Tras cada respuesta, ";" pide otra solución y "." termina.' },
    { q: 'padre(juan, X).', more: 1 },
    { q: 'madre(M, sofia).' },
    { c: 'La coma es un Y lógico: padre y madre de luis en una sola consulta.' },
    { q: 'padre(P, luis), madre(M, luis).' },
    { c: 'Tu turno: resuelve los retos del panel izquierdo.' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Quiénes son los hijos de <code>lucia</code>? Escribe la consulta en la terminal.',
      ref: 'madre(lucia, X).', usa: ['lucia'],
      pistas: ['Usa el predicado madre/2 con una variable.', 'madre(lucia, H).'] },
    { tipo: 'query', enunciado: '¿Quién es el padre de los hijos de <code>ana</code>? Obtén padre <b>e</b> hijo en una sola consulta.',
      ref: 'padre(P, H), madre(ana, H).',
      pistas: ['Combina dos metas con coma; la misma variable (el hijo) las conecta.', 'madre(ana, H), padre(P, H).'] },
    { tipo: 'program', enunciado: 'Agrega al programa que <code>carmen</code> es madre de <code>diego</code> y vuelve a consultar.',
      check: 'madre(carmen, diego)',
      pistas: ['Escribe un hecho nuevo en el editor y pulsa Consultar.', 'madre(carmen, diego).'] },
  ],
},
{
  id: '2a', nivel: 2, titulo: 'Reglas y recursión', tema: 'La familia crece',
  fuente: 'Bratko, cap. 1.2–1.3',
  archivo: 'familia2',
  teoria: `
<p>Una <b>regla</b> define una relación a partir de otras: <code>Cabeza :- Cuerpo.</code> se lee «Cabeza es verdad <i>si</i> Cuerpo es verdad».</p>
<p>Varias cláusulas con la misma cabeza son un <b>O lógico</b>: <code>progenitor/2</code> vale si es padre <i>o</i> madre.</p>
<p>Las variables del cuerpo que no están en la cabeza (como <code>P</code> en <code>abuelo/2</code>) son intermedias: Prolog las busca.</p>
<p>La <b>recursión</b> define relaciones de longitud arbitraria: un ancestro es un progenitor, o el progenitor de un ancestro.</p>
<p><code>X \\= Y</code> es verdad si <code>X</code> y <code>Y</code> <b>no</b> unifican.</p>`,
  programa:
`% familia2.pl — Reglas (Bratko, cap. 1.2)
padre(juan, pedro).   padre(juan, ana).
padre(pedro, luis).   padre(pedro, sofia).
padre(jorge, carmen).
madre(maria, pedro).  madre(maria, ana).
madre(lucia, luis).   madre(lucia, sofia).
madre(ana, carmen).

% progenitor(X, Y): X es padre o madre de Y.
progenitor(X, Y) :- padre(X, Y).
progenitor(X, Y) :- madre(X, Y).

% abuelo(A, N): A es abuelo de N.
abuelo(A, N) :- padre(A, P), progenitor(P, N).

% Reto 2: define hermano/2 aquí.

% Reto 3: define ancestro/2 aquí.
`,
  demo: [
    { c: 'Las reglas derivan conocimiento nuevo a partir de los hechos.' },
    { consult: true },
    { c: 'progenitor/2 tiene dos cláusulas: padre O madre.' },
    { q: 'progenitor(X, luis).', more: 1 },
    { c: 'abuelo/2 encadena dos metas a través de la variable intermedia P.' },
    { q: 'abuelo(juan, N).', more: 2 },
    { c: 'Veamos cómo lo resuelve Prolog: el árbol de búsqueda (pestaña Árbol).' },
    { tree: 'abuelo(juan, N).', max: 5 },
    { c: 'Cada nodo es la lista de metas pendientes; □ = éxito, ✗ = callejón sin salida.' },
    { c: 'Tu turno: define hermano/2 y ancestro/2 en el editor.' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Quiénes son los nietos de <code>maria</code>? (no existe <code>abuela/2</code>: combina metas).',
      ref: 'madre(maria, P), progenitor(P, N).', usa: ['maria'],
      pistas: ['Nieto = hijo de un hijo.', 'madre(maria, P), progenitor(P, N).'] },
    { tipo: 'program', enunciado: 'Define <code>hermano(X, Y)</code>: comparten un progenitor y son distintos.',
      check: 'hermano(luis, sofia), hermano(pedro, ana), \\+ hermano(luis, luis), \\+ hermano(luis, carmen)',
      pistas: ['Necesitas un progenitor común P y la condición X \\= Y.', 'hermano(X, Y) :- progenitor(P, X), progenitor(P, Y), X \\= Y.'] },
    { tipo: 'program', enunciado: 'Define <code>ancestro(A, D)</code> de forma recursiva.',
      check: 'ancestro(juan, luis), ancestro(maria, carmen), ancestro(jorge, carmen), \\+ ancestro(luis, juan)',
      pistas: ['Caso base: un progenitor es ancestro. Caso recursivo: progenitor de un ancestro.',
               'ancestro(X, Y) :- progenitor(X, Y).\nancestro(X, Y) :- progenitor(X, Z), ancestro(Z, Y).'] },
  ],
},
{
  id: '2b', nivel: 2, titulo: 'Recursión', tema: 'Viajes en coche, tren y avión',
  fuente: 'Learn Prolog Now!, ejercicio 3.4',
  archivo: 'viajes',
  teoria: `
<p>Ejercicio clásico de <i>Learn Prolog Now!</i>: una base de conexiones directas por coche, tren y avión.</p>
<p>Para saber si se puede ir de <code>X</code> a <code>Y</code> necesitas una relación <b>transitiva</b>: hay un tramo directo, o un tramo hacia <code>Z</code> y desde <code>Z</code> se puede llegar a <code>Y</code>.</p>
<p>Las estructuras guardan la <b>ruta</b>: <code>ir(valmont, metz, ir(metz, paris))</code>. Un término compuesto es un dato, no una llamada.</p>`,
  programa:
`% viajes.pl — Learn Prolog Now!, ejercicio 3.4
byCar(auckland, hamilton).
byCar(hamilton, raglan).
byCar(valmont, saarbruecken).
byCar(valmont, metz).

byTrain(metz, frankfurt).
byTrain(saarbruecken, frankfurt).
byTrain(metz, paris).
byTrain(saarbruecken, paris).

byPlane(frankfurt, bangkok).
byPlane(frankfurt, singapore).
byPlane(paris, losAngeles).
byPlane(bangkok, auckland).
byPlane(singapore, auckland).
byPlane(losAngeles, auckland).

% directo(X, Y): hay un tramo directo de X a Y.
directo(X, Y) :- byCar(X, Y).
directo(X, Y) :- byTrain(X, Y).
directo(X, Y) :- byPlane(X, Y).

% Reto 1: define viajar/2 aquí.

% Reto 3: define viajar/3 aquí.
`,
  demo: [
    { consult: true },
    { c: 'Tramos directos que salen de metz:' },
    { q: 'directo(metz, Y).', more: 1 },
    { c: '¿Hay vuelo directo de valmont a auckland? No... pero quizá con escalas.' },
    { q: 'directo(valmont, auckland).' },
    { c: 'Necesitamos recursión: viajar(X, Y) si hay tramo directo, o tramo X→Z y viajar(Z, Y).' },
    { c: 'Tu turno: define viajar/2 en el editor (reto 1).' },
  ],
  retos: [
    { tipo: 'program', enunciado: 'Define <code>viajar(X, Y)</code>: se puede llegar de X a Y con uno o más tramos.',
      check: 'viajar(valmont, raglan), viajar(metz, auckland), \\+ viajar(raglan, valmont)',
      pistas: ['Dos cláusulas: caso base con directo/2 y caso recursivo.', 'viajar(X, Y) :- directo(X, Y).\nviajar(X, Y) :- directo(X, Z), viajar(Z, Y).'] },
    { tipo: 'query', enunciado: '¿A qué ciudades se puede viajar desde <code>saarbruecken</code>?',
      ref: 'member(X, [frankfurt, paris, bangkok, singapore, losAngeles, auckland, hamilton, raglan]).', usa: ['viajar', 'saarbruecken'],
      pistas: ['Usa tu viajar/2 con una variable.', 'viajar(saarbruecken, X).'] },
    { tipo: 'program', enunciado: 'Define <code>viajar(X, Y, Ruta)</code> que construya la ruta: <code>ir(X, Y)</code> si es directo, <code>ir(X, Z, Resto)</code> si hay escala.',
      check: 'viajar(valmont, paris, ir(valmont, metz, ir(metz, paris))), viajar(metz, paris, ir(metz, paris))',
      pistas: ['Igual que viajar/2, pero la cabeza construye el término.', 'viajar(X, Y, ir(X, Y)) :- directo(X, Y).\nviajar(X, Y, ir(X, Z, R)) :- directo(X, Z), viajar(Z, Y, R).'] },
  ],
},
{
  id: '3a', nivel: 3, titulo: 'Unificación', tema: 'Líneas verticales y horizontales',
  fuente: 'Learn Prolog Now!, sección 2.1–2.2',
  archivo: 'lineas',
  teoria: `
<p><b>Unificar</b> dos términos = encontrar valores para sus variables que los hagan idénticos. Es el mecanismo central de Prolog; <code>=</code> lo invoca directamente.</p>
<ul><li>Dos átomos unifican si son iguales.</li>
<li>Una variable unifica con cualquier término (y queda ligada).</li>
<li>Dos términos compuestos unifican si tienen el mismo nombre, la misma aridad y sus argumentos unifican.</li></ul>
<p>Con esto, la geometría se expresa <i>sin cálculo</i>: una línea es vertical si sus dos puntos comparten la <code>X</code>.</p>`,
  programa:
`% lineas.pl — Learn Prolog Now!, sección 2.2
% punto(X, Y)   linea(Punto1, Punto2)

vertical(linea(punto(X, _), punto(X, _))).

% Reto 1: define horizontal/1 aquí.
`,
  demo: [
    { c: 'El operador = unifica. Mismo nombre y aridad: se unifican los argumentos.' },
    { q: 'f(X, b) = f(a, Y).' },
    { q: 'fecha(D, nov, 2026) = fecha(19, M, A).' },
    { c: 'Distinto nombre o aridad: no unifican.' },
    { q: 'f(a) = g(a).' },
    { c: 'Listas: [Cabeza|Cola] separa el primer elemento del resto.' },
    { q: '[H|T] = [1, 2, 3].' },
    { consult: true },
    { c: 'vertical/1 no calcula nada: solo exige la misma X en ambos puntos.' },
    { q: 'vertical(linea(punto(1, 1), punto(1, 3))).' },
    { q: 'vertical(linea(punto(1, 1), punto(3, 2))).' },
    { c: '¿Qué puntos forman una vertical con punto(2, 3)? _A = cualquier valor.' },
    { q: 'vertical(linea(punto(2, 3), P)).' },
  ],
  retos: [
    { tipo: 'program', enunciado: 'Define <code>horizontal/1</code>: los dos puntos comparten la <code>Y</code>.',
      check: 'horizontal(linea(punto(1, 5), punto(9, 5))), \\+ horizontal(linea(punto(1, 5), punto(9, 6)))',
      pistas: ['Copia vertical/1 y cambia qué coordenada se comparte.', 'horizontal(linea(punto(_, Y), punto(_, Y))).'] },
    { tipo: 'query', enunciado: 'Encuentra el punto <code>P</code> tal que <code>linea(punto(1,1), P)</code> sea vertical <b>y</b> horizontal.',
      ref: 'P = punto(1, 1).', usa: ['vertical', 'horizontal'],
      pistas: ['Combina vertical y horizontal sobre la misma línea.', 'vertical(linea(punto(1,1), P)), horizontal(linea(punto(1,1), P)).'] },
    { tipo: 'query', enunciado: 'Unifica <code>k(s(g), Y)</code> con <code>k(X, t(k))</code> (LPN ej. 2.1).',
      ref: 'X = s(g), Y = t(k).',
      pistas: ['Usa el operador =.', 'k(s(g), Y) = k(X, t(k)).'] },
  ],
},
{
  id: '3b', nivel: 3, titulo: 'Unificación', tema: 'El crucigrama',
  fuente: 'Learn Prolog Now!, ejercicio 2.4',
  archivo: 'crucigrama',
  teoria: `
<p>Seis palabras italianas de 7 letras deben llenar un crucigrama: tres verticales (V1–V3) y tres horizontales (H1–H3) que se cruzan en las letras 2, 4 y 6.</p>
<pre class="grid">      V1  V2  V3
      ·   ·   ·
H1  · ■ · ■ · ■ ·
      ·   ·   ·
H2  · ■ · ■ · ■ ·
      ·   ·   ·
H3  · ■ · ■ · ■ ·
      ·   ·   ·</pre>
<p>Cada <code>■</code> es una letra compartida. Si la misma <b>variable</b> aparece en dos llamadas a <code>word/8</code>, la unificación obliga a que la letra coincida: el crucigrama se resuelve solo.</p>`,
  programa:
`% crucigrama.pl — Learn Prolog Now!, ejercicio 2.4
% word(Palabra, L1, L2, L3, L4, L5, L6, L7)
word(astante, a,s,t,a,n,t,e).
word(astoria, a,s,t,o,r,i,a).
word(baratto, b,a,r,a,t,t,o).
word(cobalto, c,o,b,a,l,t,o).
word(pistola, p,i,s,t,o,l,a).
word(statale, s,t,a,t,a,l,e).

% Reto 1: define crossword(V1, V2, V3, H1, H2, H3).
% La letra 2 de V1 es la letra 2 de H1, la 4 de V1 es la 2 de H2, ...
`,
  demo: [
    { consult: true },
    { c: 'Palabras que empiezan con a, s, t (el resto no importa: _):' },
    { q: 'word(W, a, s, t, _, _, _, _).', more: 1 },
    { c: 'Una variable compartida exige letras iguales: palabras cuya 1.ª y 7.ª letra coinciden.' },
    { q: 'word(W, L, _, _, _, _, _, L).' },
    { c: 'Esa es la idea del crucigrama: los cruces son variables compartidas.' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Qué palabras tienen una <code>a</code> como 4.ª letra?',
      ref: 'member(W, [astante, baratto, cobalto]).', usa: ['word'],
      pistas: ['Pon el átomo a en la posición 4 y _ en las demás.', 'word(W, _, _, _, a, _, _, _).'] },
    { tipo: 'program', enunciado: 'Define <code>crossword/6</code> y resuelve el crucigrama.',
      check: 'crossword(astante, cobalto, pistola, astoria, baratto, statale)',
      pistas: ['Seis llamadas a word/8. Nombra los cruces: V1H1 = letra 2 de V1 y letra 2 de H1.',
               'crossword(V1,V2,V3,H1,H2,H3) :-\n  word(V1,_,A,_,B,_,C,_), word(V2,_,D,_,E,_,F,_), word(V3,_,G,_,H,_,I,_),\n  word(H1,_,A,_,D,_,G,_), word(H2,_,B,_,E,_,H,_), word(H3,_,C,_,F,_,I,_).'] },
  ],
},
{
  id: '4a', nivel: 4, titulo: 'Backtracking', tema: 'Coloreado de mapas',
  fuente: 'Bratko · Sterling & Shapiro, cap. 14',
  archivo: 'mapa',
  teoria: `
<p>Colorea los estados del noroeste de México con 3 colores sin que dos vecinos compartan color.</p>
<p>Prolog prueba un color; si una restricción falla, <b>retrocede</b> (<i>backtracking</i>) a la última elección y prueba la siguiente alternativa. Lo hace automáticamente: no escribes ciclos.</p>
<p><b>El orden importa</b>: probar cada restricción en cuanto sus variables tienen valor (<code>colorear/6</code>) poda el árbol; generar todo y probar al final (<code>colorear_gt/6</code>) explora muchos más nodos. Compáralo en la pestaña Árbol.</p>
<pre class="grid">BC ── SON ── CHIH
│      │    ╱   │
BCS    SIN ─── DGO</pre>`,
  programa:
`% mapa.pl — Coloreado del noroeste de México
color(rojo).  color(verde).  color(azul).

% Elegir y probar en cuanto se puede (poda temprana).
colorear(BC, BCS, SON, CHIH, SIN, DGO) :-
    color(BC),
    color(BCS),  BCS \\= BC,
    color(SON),  SON \\= BC,
    color(CHIH), CHIH \\= SON,
    color(SIN),  SIN \\= SON, SIN \\= CHIH,
    color(DGO),  DGO \\= CHIH, DGO \\= SIN.

% Generar todo y probar al final.
colorear_gt(BC, BCS, SON, CHIH, SIN, DGO) :-
    color(BC), color(BCS), color(SON), color(CHIH), color(SIN), color(DGO),
    BCS \\= BC, SON \\= BC, CHIH \\= SON,
    SIN \\= SON, SIN \\= CHIH, DGO \\= CHIH, DGO \\= SIN.

% Reto 3: define colorear7/7 agregando Coahuila (COA).
`,
  demo: [
    { consult: true },
    { q: 'colorear(BC, BCS, SON, CHIH, SIN, DGO).', more: 1 },
    { c: 'Árbol de búsqueda con poda temprana (✗ = restricción violada → retroceso):' },
    { tree: 'colorear(BC, BCS, SON, CHIH, SIN, DGO).', max: 1 },
    { c: 'Ahora generar-y-probar: mismo resultado, muchos más nodos.' },
    { tree: 'colorear_gt(BC, BCS, SON, CHIH, SIN, DGO).', max: 1 },
    { c: 'Lección: en Prolog el orden de las metas define el costo de la búsqueda.' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Cuántas coloraciones válidas existen? Obtén el número en una variable <code>N</code>.',
      ref: 'aggregate_all(count, colorear(_, _, _, _, _, _), N).', usa: ['colorear'],
      pistas: ['aggregate_all(count, Meta, N) cuenta las soluciones de Meta.', 'aggregate_all(count, colorear(_,_,_,_,_,_), N).'] },
    { tipo: 'query', enunciado: 'Encuentra todas las coloraciones en que Sonora y Durango son <code>azul</code>.',
      ref: 'colorear(BC, BCS, azul, CHIH, SIN, azul).',
      pistas: ['Fija argumentos con átomos en vez de variables.', 'colorear(BC, BCS, azul, CHIH, SIN, azul).'] },
    { tipo: 'program', enunciado: 'Define <code>colorear7/7</code> agregando Coahuila (COA), vecina de Chihuahua y Durango.',
      check: "colorear7(_,_,_,_,_,_,_), forall(colorear7(BC,BCS,SON,CHIH,SIN,DGO,COA), (BCS \\== BC, SON \\== BC, CHIH \\== SON, SIN \\== SON, SIN \\== CHIH, DGO \\== CHIH, DGO \\== SIN, COA \\== CHIH, COA \\== DGO))",
      pistas: ['Reusa colorear/6 y agrega color(COA) con sus dos restricciones.', 'colorear7(BC,BCS,SON,CHIH,SIN,DGO,COA) :-\n    colorear(BC,BCS,SON,CHIH,SIN,DGO),\n    color(COA), COA \\= CHIH, COA \\= DGO.'] },
  ],
},
{
  id: '4b', nivel: 4, titulo: 'Backtracking', tema: 'N reinas',
  fuente: 'Sterling & Shapiro, cap. 14 · Bratko, cap. 4',
  archivo: 'reinas',
  teoria: `
<p>Coloca N reinas en un tablero N×N sin que se ataquen. Representación: lista <code>Qs</code> donde el elemento i es la fila de la reina en la columna i.</p>
<p>Al usar una permutación de 1..N ya no hay dos reinas en la misma fila ni columna; solo faltan las <b>diagonales</b>: dos reinas a distancia D en columnas no pueden diferir en D filas.</p>
<p><code>colocar/3</code> elige una fila libre, verifica que sea <b>segura</b> contra las ya colocadas y continúa. Si nada sirve, Prolog retrocede a la elección anterior.</p>
<p><code>=\\=</code> compara valores aritméticos; <code>is</code> evalúa una expresión (lo verás a fondo en el nivel 5).</p>`,
  programa:
`% reinas.pl — N reinas (Sterling & Shapiro, cap. 14)
reinas(N, Qs) :-
    numlist(1, N, Filas),
    colocar(Filas, [], Qs).

colocar([], Qs, Qs).
colocar(Libres, Puestas, Qs) :-
    elegir(Q, Libres, Resto),
    segura(Q, Puestas, 1),
    colocar(Resto, [Q|Puestas], Qs).

elegir(X, [X|T], T).
elegir(X, [H|T], [H|R]) :- elegir(X, T, R).

segura(_, [], _).
segura(Q, [Q1|Qs], D) :-
    Q =\\= Q1 + D,
    Q =\\= Q1 - D,
    D1 is D + 1,
    segura(Q, Qs, D1).

% Reto 2: define reinas_gt/2 (generar y probar con permutation/2).
`,
  demo: [
    { consult: true },
    { q: 'reinas(4, Qs).', more: 1 },
    { c: 'Mira el retroceso: cada ✗ es una reina atacada; Prolog vuelve a la elección anterior.' },
    { tree: 'reinas(4, Qs).', max: 1 },
    { c: 'Con 8 reinas el árbol es enorme, pero la consulta es instantánea:' },
    { q: 'reinas(8, Qs).' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Cuántas soluciones tiene el problema de las 8 reinas? Obtén <code>N</code>.',
      ref: 'aggregate_all(count, reinas(8, _), N).', usa: ['reinas'],
      pistas: ['Cuenta soluciones con aggregate_all/3.', 'aggregate_all(count, reinas(8, _), N).'] },
    { tipo: 'program', enunciado: 'Escribe <code>reinas_gt(N, Qs)</code> con generar-y-probar: <code>permutation/2</code> y luego verificar todas las diagonales.',
      check: 'aggregate_all(count, reinas_gt(6, _), 4), reinas_gt(4, [2,4,1,3])',
      pistas: ['Genera con permutation(Filas, Qs) y verifica cada reina contra las siguientes con segura/3.',
               'reinas_gt(N, Qs) :-\n    numlist(1, N, Fs), permutation(Fs, Qs), todas_seguras(Qs).\ntodas_seguras([]).\ntodas_seguras([Q|Qs]) :- segura(Q, Qs, 1), todas_seguras(Qs).'] },
  ],
},
{
  id: '5', nivel: 5, titulo: 'Aritmética simbólica', tema: 'Peano y Torres de Hanói',
  fuente: 'Sterling & Shapiro, cap. 3 · Bratko, cap. 3',
  archivo: 'peano',
  teoria: `
<p>Los números de <b>Peano</b> se construyen con <code>0</code> y el sucesor <code>s/1</code>: 2 es <code>s(s(0))</code>. La aritmética se vuelve <b>pura unificación</b>, y por eso las relaciones funcionan en varias direcciones.</p>
<p><code>suma(X, Y, Z)</code> sirve para sumar, restar (<code>suma(X, s(0), s(s(s(0))))</code>) o descomponer un número en todos los pares posibles.</p>
<p><code>=</code> solo unifica: <code>X = 2 + 3</code> deja el término <code>2+3</code>. <code>is</code> <b>evalúa</b>: <code>X is 2 + 3</code> da <code>5</code>. Comparadores aritméticos: <code>=:=</code>, <code>=\\=</code>, <code>&lt;</code>, <code>=&lt;</code>, <code>&gt;</code>, <code>&gt;=</code>.</p>
<p><b>Hanói</b>: para mover N discos de <code>De</code> a <code>A</code>, mueve N−1 a la vía, el disco grande a su destino y los N−1 encima. Necesita 2ᴺ−1 movimientos.</p>`,
  programa:
`% peano.pl — Números de Peano y Torres de Hanói
% nat(N): N es un natural de Peano: 0, s(0), s(s(0)), ...
nat(0).
nat(s(N)) :- nat(N).

% suma(X, Y, Z): Z = X + Y
suma(0, Y, Y).
suma(s(X), Y, s(Z)) :- suma(X, Y, Z).

% a_entero(P, N): convierte un Peano a entero
a_entero(0, 0).
a_entero(s(P), N) :- a_entero(P, N0), N is N0 + 1.

% hanoi(N, De, A, Via, Movs): movimientos De-A para N discos
hanoi(0, _, _, _, []).
hanoi(N, De, A, Via, Movs) :-
    N > 0, N1 is N - 1,
    hanoi(N1, De, Via, A, M1),
    hanoi(N1, Via, A, De, M2),
    append(M1, [De-A|M2], Movs).

% Reto 3: define mult/3 aquí.
`,
  demo: [
    { consult: true },
    { c: 'Sumar con Peano es unificar: 1 + 2 = 3.' },
    { q: 'suma(s(0), s(s(0)), Z).' },
    { c: 'La misma relación sirve para restar:' },
    { q: 'suma(X, s(0), s(s(s(0)))).' },
    { c: '= unifica sin evaluar; is evalúa.' },
    { q: 'X = 2 + 3.' },
    { q: 'X is 2 + 3.' },
    { c: 'Hanói con 2 discos (izq → der, usando centro):' },
    { q: 'hanoi(2, izq, der, centro, M).' },
    { tree: 'suma(X, Y, s(0)).', max: 2 },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Usa <code>suma/3</code> al revés: ¿qué pares <code>X</code>, <code>Y</code> suman <code>s(s(s(0)))</code>?',
      ref: 'suma(X, Y, s(s(s(0)))).', usa: ['suma'],
      pistas: ['Deja libres los dos primeros argumentos y pide todas las soluciones con ;.', 'suma(X, Y, s(s(s(0)))).'] },
    { tipo: 'query', enunciado: '¿Cuántos movimientos necesita Hanói con 5 discos? Obtén el número en <code>N</code>.',
      ref: 'hanoi(5, a, b, c, _M), length(_M, N).', usa: ['hanoi'],
      pistas: ['Calcula la lista de movimientos y mide su longitud con length/2.', 'hanoi(5, a, b, c, M), length(M, N).'] },
    { tipo: 'program', enunciado: 'Define <code>mult(X, Y, Z)</code> en Peano usando <code>suma/3</code> (0·Y = 0; s(X)·Y = Y + X·Y).',
      check: 'mult(s(s(0)), s(s(s(0))), Z), a_entero(Z, 6), mult(0, s(0), 0)',
      pistas: ['Dos cláusulas: caso base con 0 y caso recursivo con s(X).',
               'mult(0, _, 0).\nmult(s(X), Y, Z) :- mult(X, Y, Z0), suma(Y, Z0, Z).'] },
  ],
},
{
  id: '6', nivel: 6, titulo: 'Listas', tema: 'P-99, quicksort y mergesort',
  fuente: 'P-99: Ninety-Nine Prolog Problems · Bratko, cap. 3',
  archivo: 'listas',
  teoria: `
<p>Una lista es <code>[]</code> o <code>[Cabeza|Cola]</code>. <code>[a,b,c]</code> es azúcar para <code>[a|[b|[c|[]]]]</code>.</p>
<p>Casi todo predicado de listas tiene un <b>caso base</b> (lista vacía) y un <b>caso recursivo</b> sobre la cola.</p>
<p>Un <b>acumulador</b> guarda el resultado parcial: <code>invertir/3</code> es lineal, mientras que invertir con <code>append</code> es cuadrático.</p>
<p><code>append/3</code> es relacional: concatena, parte una lista o busca prefijos y sufijos. <b>Quicksort</b> parte la lista con un pivote; <b>mergesort</b> la divide a la mitad y mezcla.</p>`,
  programa:
`% listas.pl — Problemas P-99 y ordenamiento
% ultimo(X, L): X es el último elemento de L  (P01)
ultimo(X, [X]).
ultimo(X, [_|T]) :- ultimo(X, T).

% longitud(L, N): N elementos  (P04)
longitud([], 0).
longitud([_|T], N) :- longitud(T, N0), N is N0 + 1.

% invertir(L, R) con acumulador  (P05)
invertir(L, R) :- invertir(L, [], R).
invertir([], Acc, Acc).
invertir([H|T], Acc, R) :- invertir(T, [H|Acc], R).

% quicksort(L, S): ordena L con pivote
quicksort([], []).
quicksort([P|Xs], S) :-
    particion(P, Xs, Men, May),
    quicksort(Men, S1), quicksort(May, S2),
    append(S1, [P|S2], S).

% particion(P, L, Men, May): Men =< P < May
particion(_, [], [], []).
particion(P, [X|Xs], [X|M], G) :- X =< P, particion(P, Xs, M, G).
particion(P, [X|Xs], M, [X|G]) :- X > P, particion(P, Xs, M, G).

% Retos: define comprimir/2 y mergesort/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'X = [a|[b|[c|[]]]].' },
    { q: 'ultimo(X, [p, r, o, l, o, g]).' },
    { q: 'invertir([1, 2, 3], R).' },
    { c: 'append/3 parte una lista en todas las formas posibles:' },
    { q: 'append(X, Y, [1, 2]).', more: 2 },
    { q: 'quicksort([3, 1, 4, 1, 5, 9, 2, 6], S).' },
    { tree: 'invertir([a, b], R).', max: 1 },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Cuál es el último elemento de <code>[p,r,o,l,o,g]</code>? Usa <code>ultimo/2</code>.',
      ref: 'ultimo(X, [p, r, o, l, o, g]).', usa: ['ultimo'],
      pistas: ['El primer argumento es la variable.', 'ultimo(X, [p, r, o, l, o, g]).'] },
    { tipo: 'query', enunciado: 'Con <code>append/3</code>, obtén todas las formas de partir <code>[a,b,c]</code> en dos listas <code>X</code> e <code>Y</code>.',
      ref: 'append(X, Y, [a, b, c]).', usa: ['append'],
      pistas: ['La lista conocida va en el tercer argumento.', 'append(X, Y, [a, b, c]).'] },
    { tipo: 'program', enunciado: 'Define <code>comprimir(L, C)</code> (P08): elimina duplicados <b>consecutivos</b>. <code>[a,a,b,a]</code> → <code>[a,b,a]</code>.',
      check: 'comprimir([a,a,a,b,c,c,a,a,d,e,e,e,e], [a,b,c,a,d,e]), comprimir([], []), comprimir([x], [x])',
      pistas: ['Casos: lista vacía, un elemento, dos iguales al frente, dos distintos al frente.',
               'comprimir([], []).\ncomprimir([X], [X]).\ncomprimir([X,X|T], C) :- comprimir([X|T], C).\ncomprimir([X,Y|T], [X|C]) :- X \\== Y, comprimir([Y|T], C).'] },
    { tipo: 'program', enunciado: 'Define <code>mergesort(L, S)</code>: divide a la mitad, ordena cada parte y mézclalas con <code>mezclar/3</code>.',
      check: 'mergesort([5,3,8,1,9,2], [1,2,3,5,8,9]), mergesort([], []), mergesort([2,1,2], [1,2,2])',
      pistas: ['Usa length/2 y append/3 para partir; mezclar compara las cabezas.',
               'mergesort([], []).\nmergesort([X], [X]).\nmergesort(L, S) :-\n    L = [_,_|_], length(L, N), H is N // 2,\n    length(A, H), append(A, B, L),\n    mergesort(A, SA), mergesort(B, SB), mezclar(SA, SB, S).\nmezclar([], L, L).\nmezclar([X|Xs], [], [X|Xs]).\nmezclar([X|Xs], [Y|Ys], [X|Zs]) :- X =< Y, mezclar(Xs, [Y|Ys], Zs).\nmezclar([X|Xs], [Y|Ys], [Y|Zs]) :- X > Y, mezclar([X|Xs], Ys, Zs).'] },
  ],
},
{
  id: '7', nivel: 7, titulo: 'Corte, negación, setof', tema: 'El problema de la cebra',
  fuente: 'Bratko, cap. 5 y 7 · Rosetta Code (Zebra puzzle)',
  archivo: 'cebra',
  teoria: `
<p>El <b>corte</b> <code>!</code> descarta las alternativas pendientes de la cláusula actual. Es <i>verde</i> si solo ahorra trabajo y <i>rojo</i> si cambia el significado.</p>
<p><code>\\+ G</code> es la <b>negación por fallo</b>: es cierta si <code>G</code> no se puede probar. Úsala con variables ya ligadas.</p>
<p><code>findall/3</code> junta todas las soluciones (lista vacía si no hay ninguna). <code>bagof/3</code> agrupa por las variables libres. <code>setof/3</code> además <b>ordena y quita repetidos</b>. <code>P^Meta</code> indica que <code>P</code> no agrupa.</p>
<p>El <b>problema de la cebra</b> se resuelve declarando las pistas con <code>member/2</code> sobre una lista de 5 casas: la unificación y el backtracking hacen el resto.</p>`,
  programa:
`% cebra.pl — Corte, negación por fallo, setof y el problema de la cebra
% max(X, Y, M): corte verde
max(X, Y, X) :- X >= Y, !.
max(_, Y, Y).

persona(ana). persona(beto). persona(carla). persona(diego).
casado(ana, beto).
casado(beto, ana).
edad(ana, 21). edad(beto, 19). edad(carla, 21). edad(diego, 23).

% soltero(X): negación por fallo (X ya ligado por persona/1)
soltero(X) :- persona(X), \\+ casado(X, _).

% derecha(A, B, L): A está justo a la izquierda de B
derecha(A, B, [A,B|_]).
derecha(A, B, [_|T]) :- derecha(A, B, T).
junto(A, B, L) :- derecha(A, B, L) ; derecha(B, A, L).

% casa(Nacionalidad, Color, Mascota, Bebida, Cigarro)
cebra(Duenio, Agua, Casas) :-
    Casas = [casa(noruego,_,_,_,_), _, casa(_,_,_,leche,_), _, _],
    member(casa(ingles, rojo, _, _, _), Casas),
    member(casa(espanol, _, perro, _, _), Casas),
    member(casa(_, verde, _, cafe, _), Casas),
    member(casa(ucraniano, _, _, te, _), Casas),
    derecha(casa(_, marfil, _, _, _), casa(_, verde, _, _, _), Casas),
    member(casa(_, _, caracol, _, oldgold), Casas),
    member(casa(_, amarillo, _, _, kools), Casas),
    junto(casa(_, _, _, _, chesterfield), casa(_, _, zorro, _, _), Casas),
    junto(casa(_, _, _, _, kools), casa(_, _, caballo, _, _), Casas),
    member(casa(_, _, _, jugo, luckystrike), Casas),
    member(casa(japones, _, _, _, parliament), Casas),
    junto(casa(noruego, _, _, _, _), casa(_, azul, _, _, _), Casas),
    member(casa(Duenio, _, cebra, _, _), Casas),
    member(casa(Agua, _, _, agua, _), Casas).

% Reto 4: define clasifica/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'max(3, 7, M).' },
    { c: 'Negación por fallo: solteros son personas que no están casadas.' },
    { q: 'soltero(X).', more: 1 },
    { c: 'findall junta todo; bagof agrupa por la variable libre P; setof ordena sin repetir.' },
    { q: 'findall(E, edad(_, E), Es).' },
    { q: 'bagof(P, edad(P, E), Ps).', more: 2 },
    { c: 'El problema de la cebra: 15 pistas, una consulta.' },
    { q: 'cebra(D, A, _).' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Quiénes son solteros?',
      ref: 'soltero(X).', usa: ['soltero'],
      pistas: ['Ya existe soltero/1.', 'soltero(X).'] },
    { tipo: 'query', enunciado: 'Con <code>setof/3</code>, obtén la lista ordenada y sin repetidos de todas las edades.',
      ref: 'setof(E, P^edad(P, E), Es).', usa: ['setof'],
      pistas: ['Sin P^ setof agrupa por persona; con P^ las junta todas.', 'setof(E, P^edad(P, E), Es).'] },
    { tipo: 'query', enunciado: 'Resuelve el acertijo: ¿quién tiene la cebra y quién bebe agua?',
      ref: 'cebra(D, A, _).', usa: ['cebra'],
      pistas: ['cebra/3 devuelve dueño, bebedor de agua y las casas.', 'cebra(D, A, _).'] },
    { tipo: 'program', enunciado: 'Define <code>clasifica(N, Tipo)</code> con cortes: <code>negativo</code>, <code>cero</code> o <code>positivo</code>.',
      check: 'clasifica(-3, negativo), clasifica(0, cero), clasifica(5, positivo), \\+ clasifica(5, cero), \\+ clasifica(-1, cero)',
      pistas: ['Pon primero los casos con condición y termina con el caso general; el corte evita que el último se use por error.',
               'clasifica(N, negativo) :- N < 0, !.\nclasifica(0, cero) :- !.\nclasifica(N, positivo) :- N > 0.'] },
  ],
},
{
  id: '8', nivel: 8, titulo: 'Búsqueda', tema: 'Granjero, lobo, cabra y col',
  fuente: 'Bratko, cap. 11 · Clocksin & Mellish',
  archivo: 'granjero',
  teoria: `
<p>Un problema de <b>espacio de estados</b> se describe con un estado inicial, una meta y movimientos <code>mover(E, Accion, E2)</code>.</p>
<p>El granjero cruza el río con a lo sumo un pasajero. El lobo no puede quedarse solo con la cabra, ni la cabra con la col.</p>
<p>La <b>búsqueda en profundidad</b> de Prolog puede ciclar, así que llevamos una lista de <code>Visitados</code> y usamos <code>\\+ member/2</code>.</p>
<p><b>Profundidad iterativa</b>: si fijas antes la longitud de la ruta con <code>length(Ruta, _)</code>, Prolog prueba longitudes 0, 1, 2… y la primera solución es la más corta. Así se resuelven también misioneros y caníbales o las jarras.</p>`,
  programa:
`% granjero.pl — Granjero, lobo, cabra y col (búsqueda en espacio de estados)
% estado(Granjero, Lobo, Cabra, Col): orilla de cada uno (i / d)
opuesta(i, d).
opuesta(d, i).

% mover(Estado, Accion, Nuevo)
mover(estado(G, L, C, Co), solo,  estado(G2, L, C, Co))   :- opuesta(G, G2).
mover(estado(G, G, C, Co), lobo,  estado(G2, G2, C, Co))  :- opuesta(G, G2).
mover(estado(G, L, G, Co), cabra, estado(G2, L, G2, Co))  :- opuesta(G, G2).
mover(estado(G, L, C, G),  col,   estado(G2, L, C, G2))   :- opuesta(G, G2).

% seguro(E): nadie se come a nadie
seguro(estado(G, L, C, Co)) :-
    ( L == C -> G == C ; true ),
    ( C == Co -> G == C ; true ).

% resolver(Ruta): profundidad, sin repetir estados
resolver(Ruta) :-
    camino(estado(i,i,i,i), estado(d,d,d,d), [estado(i,i,i,i)], Ruta).

camino(Meta, Meta, _, []).
camino(E, Meta, Visitados, [A|As]) :-
    mover(E, A, E2),
    seguro(E2),
    \\+ member(E2, Visitados),
    camino(E2, Meta, [E2|Visitados], As).

% Reto 3: define ruta_corta/1 aquí.
`,
  demo: [
    { consult: true },
    { c: 'Desde el inicio, ¿qué movimientos hay y cuáles son seguros?' },
    { q: 'mover(estado(i,i,i,i), A, E).', more: 1 },
    { q: 'seguro(estado(d,d,i,i)).' },
    { c: 'Búsqueda en profundidad con lista de visitados:' },
    { q: 'resolver(R).', more: 1 },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Desde <code>estado(i,i,i,i)</code>, ¿qué acción <code>A</code> lleva a un estado <code>E</code> seguro?',
      ref: 'mover(estado(i,i,i,i), A, E), seguro(E).', usa: ['mover', 'seguro'],
      pistas: ['Combina mover/3 y seguro/1.', 'mover(estado(i,i,i,i), A, E), seguro(E).'] },
    { tipo: 'query', enunciado: '¿Cuántos movimientos tiene la solución más corta? Obtén <code>N</code>.',
      ref: 'aggregate_all(min(L), (resolver(_R), length(_R, L)), N).', usa: ['resolver'],
      pistas: ['Mide cada ruta con length/2 y toma el mínimo con aggregate_all(min(...)).', 'aggregate_all(min(L), (resolver(R), length(R, L)), N).'] },
    { tipo: 'program', enunciado: 'Define <code>ruta_corta(R)</code> con <b>profundidad iterativa</b>: fija la longitud con <code>length/2</code> antes de llamar a <code>camino/4</code>.',
      check: 'ruta_corta(R), length(R, 7)',
      pistas: ['length(R, _) con R libre genera listas de longitud 0, 1, 2, …; el corte se queda con la primera.',
               'ruta_corta(R) :-\n    length(R, _),\n    camino(estado(i,i,i,i), estado(d,d,d,d), [estado(i,i,i,i)], R), !.'] },
  ],
},
{
  id: '9', nivel: 9, titulo: 'Búsqueda informada', tema: '8-puzzle con A*',
  fuente: 'Bratko, cap. 12 · Russell & Norvig, cap. 3',
  archivo: 'puzzle8',
  teoria: `
<p><b>A*</b> expande primero el nodo con menor <code>f = g + h</code>: <code>g</code> es el costo recorrido y <code>h</code> la estimación hasta la meta.</p>
<p>Si <code>h</code> nunca sobreestima (es <b>admisible</b>), A* encuentra la solución óptima. Para el 8-puzzle, la <b>distancia Manhattan</b> (suma de distancias de cada ficha a su lugar) es admisible.</p>
<p>Estado: lista de 9 posiciones con <code>0</code> como hueco. Meta: <code>[1,2,3,4,5,6,7,8,0]</code>.</p>
<p>La frontera se guarda como pares <code>F-G-Estado-Camino</code> ordenados con <code>keysort/2</code>. Así la cabeza de la lista es el mejor nodo.</p>`,
  programa:
`% puzzle8.pl — 8-puzzle con A* (heurística Manhattan)
% Estado: lista de 9 posiciones, 0 = hueco
meta([1,2,3,4,5,6,7,8,0]).

% mueve(E, E2): desliza una ficha vecina al hueco
mueve(E, E2) :-
    nth0(H, E, 0),
    vecino(H, P),
    nth0(P, E, F),
    cambia(E, H, P, F, E2).

vecino(H, P) :- H mod 3 > 0, P is H - 1.
vecino(H, P) :- H mod 3 < 2, P is H + 1.
vecino(H, P) :- H >= 3, P is H - 3.
vecino(H, P) :- H < 6, P is H + 3.

cambia(E, H, P, F, E2) :-
    findall(X, ( nth0(I, E, Y),
                 ( I =:= H -> X = F ; I =:= P -> X = 0 ; X = Y ) ), E2).

% manhattan(E, D): suma de distancias de cada ficha a su lugar
manhattan(E, D) :-
    aggregate_all(sum(Di),
        ( nth0(I, E, F), F > 0, Obj is F - 1,
          Di is abs(I // 3 - Obj // 3) + abs(I mod 3 - Obj mod 3) ), D).

% astar(Inicio, Camino): lista de estados desde Inicio hasta la meta
astar(Inicio, Camino) :-
    manhattan(Inicio, H),
    astar_([H-0-Inicio-[Inicio]], [], Inv),
    reverse(Inv, Camino).

astar_([_-_-E-C|_], _, C) :- meta(E), !.
astar_([_-G-E-C|Abiertos], Cerrados, Sol) :-
    G1 is G + 1,
    findall(F-G1-E2-[E2|C],
            ( mueve(E, E2), \\+ memberchk(E2, Cerrados),
              manhattan(E2, H), F is G1 + H ),
            Hijos),
    append(Abiertos, Hijos, Todos),
    keysort(Todos, Orden),
    astar_(Orden, [E|Cerrados], Sol).

% Reto 3: define fuera_de_lugar/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'mueve([1,2,3,4,5,6,7,0,8], E).', more: 2 },
    { q: 'manhattan([1,2,3,4,0,6,7,5,8], D).' },
    { c: 'A* encuentra el camino óptimo:' },
    { q: 'astar([1,2,3,4,0,6,7,5,8], C).' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Cuál es la distancia Manhattan de <code>[1,2,3,4,5,6,0,7,8]</code>?',
      ref: 'manhattan([1,2,3,4,5,6,0,7,8], D).', usa: ['manhattan'],
      pistas: ['Llama a manhattan/2.', 'manhattan([1,2,3,4,5,6,0,7,8], D).'] },
    { tipo: 'query', enunciado: '¿Cuántos movimientos tiene la solución óptima de <code>[4,1,3,7,2,6,0,5,8]</code>? Obtén <code>N</code> (estados − 1).',
      ref: 'astar([4,1,3,7,2,6,0,5,8], _C), length(_C, _L), N is _L - 1.', usa: ['astar'],
      pistas: ['El camino incluye el estado inicial: N = longitud − 1.', 'astar([4,1,3,7,2,6,0,5,8], C), length(C, L), N is L - 1.'] },
    { tipo: 'program', enunciado: 'Define <code>fuera_de_lugar(E, N)</code>: cuántas fichas (sin contar el hueco) no están en su lugar.',
      check: 'fuera_de_lugar([1,2,3,4,5,6,0,7,8], 2), fuera_de_lugar([1,2,3,4,5,6,7,8,0], 0), fuera_de_lugar([8,1,3,4,0,2,7,6,5], 5)',
      pistas: ['Compara cada posición con la meta usando nth0/3 y cuenta con aggregate_all(count, …).',
               'fuera_de_lugar(E, N) :-\n    meta(M),\n    aggregate_all(count, ( nth0(I, E, F), F > 0, nth0(I, M, F2), F =\\= F2 ), N).'] },
  ],
},
{
  id: '10', nivel: 10, titulo: 'Planificación', tema: 'Mundo de bloques (STRIPS)',
  fuente: 'Bratko, cap. 17 · Russell & Norvig, cap. 11',
  archivo: 'bloques',
  teoria: `
<p>En <b>STRIPS</b> un estado es un conjunto de hechos (<code>sobre(c, a)</code>, <code>libre(b)</code>, <code>en_mesa(a)</code>). Cada acción tiene <b>precondiciones</b>, una lista de hechos a <b>borrar</b> y otra a <b>agregar</b>.</p>
<p>Aplicar una acción: comprobar precondiciones con <code>subset/2</code>, quitar con <code>subtract/3</code> y añadir con <code>append/3</code>. Ordenar con <code>sort/2</code> hace que estados iguales se representen igual.</p>
<p>El planificador busca hacia adelante con <b>profundidad iterativa</b>, así que encuentra el plan más corto.</p>
<p>La <b>anomalía de Sussman</b> (c sobre a; meta: a sobre b sobre c) muestra que resolver las metas una por una no basta.</p>`,
  programa:
`% bloques.pl — Mundo de bloques (STRIPS, búsqueda hacia adelante)
bloque(a). bloque(b). bloque(c).

% accion(Nombre, Precondiciones, Borrar, Agregar)
accion(mover(X, Y, Z), [libre(X), sobre(X, Y), libre(Z)],
       [sobre(X, Y), libre(Z)], [sobre(X, Z), libre(Y)]) :-
    bloque(X), bloque(Y), bloque(Z), X \\== Y, X \\== Z, Y \\== Z.
accion(a_mesa(X, Y), [libre(X), sobre(X, Y)],
       [sobre(X, Y)], [en_mesa(X), libre(Y)]) :-
    bloque(X), bloque(Y), X \\== Y.
accion(de_mesa(X, Z), [libre(X), en_mesa(X), libre(Z)],
       [en_mesa(X), libre(Z)], [sobre(X, Z)]) :-
    bloque(X), bloque(Z), X \\== Z.

% anomalía de Sussman: c sobre a; b en la mesa
inicial([en_mesa(a), sobre(c, a), libre(c), en_mesa(b), libre(b)]).

% aplicar(Estado, Accion, Nuevo)
aplicar(E, A, E2) :-
    accion(A, Pre, Borrar, Agregar),
    subset(Pre, E),
    subtract(E, Borrar, E1),
    append(Agregar, E1, E3),
    sort(E3, E2).

% plan(Inicial, Metas, Plan): profundidad iterativa (plan más corto)
plan(I, Metas, Plan) :-
    sort(I, I1),
    length(Plan, _),
    ejecutar(I1, Metas, Plan, [I1]), !.

ejecutar(E, Metas, [], _) :- subset(Metas, E).
ejecutar(E, Metas, [A|As], Vistos) :-
    aplicar(E, A, E2),
    \\+ memberchk(E2, Vistos),
    ejecutar(E2, Metas, As, [E2|Vistos]).

% Reto 3: define aplicable/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'inicial(I), aplicar(I, A, E).', more: 2 },
    { c: 'Plan para la anomalía de Sussman:' },
    { q: 'inicial(I), plan(I, [sobre(a, b), sobre(b, c)], P).' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Qué acciones <code>A</code> se pueden aplicar en el estado inicial?',
      ref: 'inicial(_I), aplicar(_I, A, _).', usa: ['aplicar'],
      pistas: ['Obtén el estado con inicial/1 y deja libre la acción en aplicar/3.', 'inicial(I), aplicar(I, A, _).'] },
    { tipo: 'query', enunciado: 'Planea la anomalía de Sussman: meta <code>[sobre(a, b), sobre(b, c)]</code>. Obtén el plan <code>P</code>.',
      ref: 'inicial(_I), plan(_I, [sobre(a, b), sobre(b, c)], P).', usa: ['plan'],
      pistas: ['plan/3 recibe estado inicial, metas y devuelve el plan.', 'inicial(I), plan(I, [sobre(a, b), sobre(b, c)], P).'] },
    { tipo: 'program', enunciado: 'Define <code>aplicable(E, A)</code>: cierto si las precondiciones de <code>A</code> se cumplen en <code>E</code> (sin aplicarla).',
      check: 'inicial(I), aplicable(I, a_mesa(c, a)), \\+ aplicable(I, de_mesa(a, b)), \\+ aplicable(I, mover(b, a, c))',
      pistas: ['Toma las precondiciones con accion/4 y compruébalas con subset/2.',
               'aplicable(E, A) :- accion(A, Pre, _, _), subset(Pre, E).'] },
  ],
},
{
  id: '11', nivel: 11, titulo: 'Árboles y grafos', tema: 'Árboles binarios P-99 y rutas',
  fuente: 'P-99 (P54–P69) · Bratko, cap. 9',
  archivo: 'arboles',
  teoria: `
<p>Un árbol binario es <code>nil</code> o <code>t(Valor, Izq, Der)</code>. Los predicados siguen la forma del árbol: un caso para <code>nil</code> y otro que se llama en ambos hijos.</p>
<p>Recorridos: <b>preorden</b> (raíz, izq, der), <b>inorden</b> (izq, raíz, der), <b>postorden</b> (izq, der, raíz).</p>
<p>Un <b>grafo</b> ponderado se guarda como hechos <code>arista(X, Y, Distancia)</code>. <code>conecta/3</code> lo vuelve no dirigido.</p>
<p>Los caminos simples llevan una lista de visitados. El más corto se obtiene con <code>aggregate_all(min(D, Ruta), …)</code>.</p>`,
  programa:
`% arboles.pl — Árboles binarios (P-99) y caminos en grafos
% Árbol: nil | t(Valor, Izq, Der)
arbol(t(a, t(b, t(d, nil, nil), t(e, nil, nil)),
           t(c, nil, t(f, t(g, nil, nil), nil)))).

% contar_hojas(T, N)  (P61)
contar_hojas(nil, 0).
contar_hojas(t(_, nil, nil), 1) :- !.
contar_hojas(t(_, I, D), N) :-
    contar_hojas(I, NI), contar_hojas(D, ND), N is NI + ND.

% inorden(T, L): izquierda, raíz, derecha
inorden(nil, []).
inorden(t(X, I, D), L) :-
    inorden(I, LI), inorden(D, LD), append(LI, [X|LD], L).

% Grafo ponderado (km aproximados)
arista(tijuana, ensenada, 100).
arista(tijuana, tecate, 50).
arista(tecate, mexicali, 130).
arista(ensenada, mexicali, 240).
arista(tijuana, rosarito, 20).
arista(rosarito, ensenada, 85).
conecta(X, Y, D) :- arista(X, Y, D) ; arista(Y, X, D).

% camino(X, Y, Ruta, Dist): caminos simples de X a Y
camino(X, Y, Ruta, D) :- camino_(X, Y, [X], R, D), reverse(R, Ruta).
camino_(X, X, V, V, 0).
camino_(X, Y, V, R, D) :-
    conecta(X, Z, D1), \\+ memberchk(Z, V),
    camino_(Z, Y, [Z|V], R, D2), D is D1 + D2.

% mas_corto(X, Y, Ruta, Dist)
mas_corto(X, Y, Ruta, D) :-
    aggregate_all(min(D0, R0), camino(X, Y, R0, D0), min(D, Ruta)).

% Reto 2: define altura/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'arbol(T), contar_hojas(T, N).' },
    { q: 'arbol(T), inorden(T, L).' },
    { q: 'camino(tijuana, ensenada, R, D).', more: 2 },
    { tree: 'inorden(t(a, t(b, nil, nil), nil), L).', max: 1 },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Obtén el recorrido inorden <code>L</code> del árbol de <code>arbol/1</code>.',
      ref: 'arbol(_T), inorden(_T, L).', usa: ['inorden'],
      pistas: ['Primero obtén el árbol con arbol/1.', 'arbol(T), inorden(T, L).'] },
    { tipo: 'program', enunciado: 'Define <code>altura(T, H)</code>: <code>nil</code> tiene altura 0; un nodo, 1 + la mayor altura de sus hijos.',
      check: 'arbol(T), altura(T, 4), altura(nil, 0), altura(t(x, nil, nil), 1)',
      pistas: ['Usa max/2 dentro de is.',
               'altura(nil, 0).\naltura(t(_, I, D), H) :- altura(I, HI), altura(D, HD), H is max(HI, HD) + 1.'] },
    { tipo: 'query', enunciado: '¿Cuál es la ruta más corta <code>R</code> y su distancia <code>D</code> de <code>tijuana</code> a <code>mexicali</code>?',
      ref: 'mas_corto(tijuana, mexicali, R, D).', usa: ['tijuana', 'mexicali'],
      pistas: ['mas_corto/4 ya existe.', 'mas_corto(tijuana, mexicali, R, D).'] },
  ],
},
{
  id: '12', nivel: 12, titulo: 'BD dinámica', tema: 'assert/retract y ELIZA',
  fuente: 'Weizenbaum (1966) · Bratko, cap. 7 · Sterling & Shapiro, cap. 14',
  archivo: 'eliza',
  teoria: `
<p>La base de conocimiento puede cambiar en ejecución: <code>assertz/1</code> agrega una cláusula, <code>retract/1</code> quita la primera que unifique y <code>retractall/1</code> quita todas.</p>
<p>Un predicado que se modifica debe declararse <code>:- dynamic nombre/aridad.</code> Si no, SWI lo trata como estático y da error de permiso.</p>
<p>Patrón típico de <b>contador</b>: <code>retract(contador(N)), N1 is N+1, assertz(contador(N1))</code>.</p>
<p><b>ELIZA</b> responde por <b>coincidencia de patrones</b>: la frase se parte en palabras y se busca la primera regla cuyo patrón unifique. La última regla atrapa todo.</p>`,
  programa:
`% eliza.pl — Base de datos dinámica y una ELIZA mínima
:- dynamic contador/1, recuerda/2.
contador(0).

% incrementa: suma 1 al contador
incrementa :-
    retract(contador(N)), N1 is N + 1, assertz(contador(N1)).

% aprende(Clave, Valor): guarda un dato reemplazando el anterior
aprende(K, V) :- retractall(recuerda(K, _)), assertz(recuerda(K, V)).

% regla(Patron, Respuesta): listas de palabras
regla([me, siento, X], [por, que, te, sientes, X, '?']).
regla([yo, soy, X], [desde, cuando, eres, X, '?']).
regla([_, madre|_], [cuentame, mas, de, tu, familia]).
regla(_, [continua, por, favor]).

% eliza(Frase, Respuesta)
eliza(Entrada, Respuesta) :-
    split_string(Entrada, " ", ".,!?", Ps),
    maplist([S, A]>>(string_lower(S, L), atom_string(A, L)), Ps, Palabras),
    once(regla(Palabras, R)),
    atomic_list_concat(R, ' ', Respuesta).

% Reto 3: define decrementa/0 aquí.
`,
  demo: [
    { consult: true },
    { q: 'incrementa, incrementa, contador(N).' },
    { q: 'aprende(nombre, ana), recuerda(nombre, X).' },
    { c: 'ELIZA busca la primera regla cuyo patrón coincida:' },
    { q: 'eliza("Yo soy estudiante", R).' },
    { q: 'eliza("Mi madre cocina rico", R).' },
    { q: 'eliza("Hola", R).' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Pregúntale a ELIZA: <code>"Me siento triste"</code>.',
      ref: 'eliza("Me siento triste", R).', usa: ['eliza'],
      pistas: ['La frase va entre comillas dobles (string).', 'eliza("Me siento triste", R).'] },
    { tipo: 'query', enunciado: 'En una sola consulta, guarda con <code>aprende/2</code> que tu <code>color</code> favorito es <code>azul</code> y léelo con <code>recuerda/2</code>.',
      ref: 'aprende(color, azul), recuerda(color, C).', usa: ['aprende', 'recuerda'],
      pistas: ['Une las dos metas con coma.', 'aprende(color, azul), recuerda(color, C).'] },
    { tipo: 'program', enunciado: 'Define <code>decrementa/0</code>: resta 1 al contador sin bajar de 0.',
      check: 'retractall(contador(_)), assertz(contador(2)), decrementa, decrementa, decrementa, contador(0), \\+ contador(-1)',
      pistas: ['Usa retract/assertz como en incrementa y un if-then-else (C -> A ; B).',
               'decrementa :-\n    retract(contador(N)),\n    ( N > 0 -> N1 is N - 1 ; N1 = 0 ),\n    assertz(contador(N1)).'] },
  ],
},
{
  id: '13', nivel: 13, titulo: 'Sistemas expertos', tema: 'Identificación de animales',
  fuente: 'Winston, Artificial Intelligence · Bratko, cap. 15',
  archivo: 'animales',
  teoria: `
<p>Un <b>sistema experto</b> separa la <b>base de conocimiento</b> (reglas <i>si… entonces</i>) del <b>motor de inferencia</b>. En Prolog el motor ya viene incluido: es la resolución.</p>
<p>Las observaciones se guardan como hechos dinámicos <code>si/1</code>. Un sistema real las pregunta al usuario; aquí las fija <code>observa/1</code>.</p>
<p>Reglas intermedias (<code>mamifero</code>, <code>ave</code>, <code>carnivoro</code>) encadenan conclusiones: es <b>encadenamiento hacia atrás</b>.</p>
<p>Explicación <b>¿cómo?</b>: <code>como/2</code> es un metaintérprete que construye el árbol de prueba con <code>clause/2</code>. Verás más de esto en el nivel 14.</p>`,
  programa:
`% animales.pl — Sistema experto de identificación de animales
:- dynamic si/1.
:- discontiguous animal/1.

% observa(Lista): fija las observaciones (en un sistema real se preguntan)
observa(Lista) :- retractall(si(_)), forall(member(X, Lista), assertz(si(X))).

% animal(Nombre): reglas de identificación
animal(guepardo) :- mamifero, carnivoro, si(color_leonado), si(manchas_oscuras).
animal(tigre)    :- mamifero, carnivoro, si(color_leonado), si(rayas_negras).
animal(cebra)    :- mamifero, ungulado, si(rayas_negras).
animal(jirafa)   :- mamifero, ungulado, si(cuello_largo), si(manchas_oscuras).
animal(avestruz) :- ave, si(no_vuela), si(cuello_largo).
animal(pinguino) :- ave, si(no_vuela), si(nada).
animal(albatros) :- ave, si(vuela_bien).

% reglas intermedias
mamifero  :- si(pelo) ; si(da_leche).
ave       :- si(plumas) ; ( si(vuela), si(pone_huevos) ).
carnivoro :- si(come_carne) ; ( si(dientes_afilados), si(garras) ).
ungulado  :- mamifero, ( si(pezunas) ; si(rumia) ).

% como(Meta, Prueba): explicación "¿cómo se concluyó?"
como(true, true) :- !.
como((A, B), (PA, PB)) :- !, como(A, PA), como(B, PB).
como((A ; B), P) :- !, ( como(A, P) ; como(B, P) ).
como(si(X), si(X)) :- !, si(X).
como(G, G :- P) :- clause(G, Cuerpo), como(Cuerpo, P).

% Reto 2: agrega la regla del murciélago aquí.
`,
  demo: [
    { consult: true },
    { q: 'observa([pelo, pezunas, rayas_negras]), animal(A).' },
    { q: 'observa([plumas, vuela_bien]), animal(A).' },
    { c: '¿Cómo lo supo? como/2 devuelve el árbol de prueba:' },
    { q: 'observa([pelo, pezunas, rayas_negras]), como(animal(cebra), P).' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Observa <code>[pelo, come_carne, color_leonado, rayas_negras]</code> e identifica el animal <code>A</code>, todo en una consulta.',
      ref: 'observa([pelo, come_carne, color_leonado, rayas_negras]), animal(A).', usa: ['observa', 'animal'],
      pistas: ['Primero observa/1, luego animal/1.', 'observa([pelo, come_carne, color_leonado, rayas_negras]), animal(A).'] },
    { tipo: 'program', enunciado: 'Agrega la regla <code>animal(murcielago)</code>: un mamífero que vuela.',
      check: 'observa([pelo, vuela]), animal(murcielago), observa([plumas, vuela_bien]), \\+ animal(murcielago)',
      pistas: ['Reutiliza la regla intermedia mamifero y el hecho si(vuela).',
               'animal(murcielago) :- mamifero, si(vuela).'] },
    { tipo: 'query', enunciado: 'Tras observar <code>[plumas, no_vuela, nada]</code>, usa <code>como/2</code> para identificar el animal <code>X</code> y su prueba <code>P</code>.',
      ref: 'observa([plumas, no_vuela, nada]), como(animal(X), P).', usa: ['como'],
      pistas: ['como(animal(X), P) prueba la meta y construye la explicación.', 'observa([plumas, no_vuela, nada]), como(animal(X), P).'] },
  ],
},
{
  id: '14', nivel: 14, titulo: 'Metaprogramación', tema: 'Metaintérprete vanilla',
  fuente: 'Sterling & Shapiro, cap. 17 · The Power of Prolog (Triska)',
  archivo: 'meta',
  teoria: `
<p>En Prolog los programas son términos: <code>clause(Cabeza, Cuerpo)</code> te da las cláusulas de un predicado. Con eso puedes escribir un <b>metaintérprete</b>, es decir, Prolog escrito en Prolog.</p>
<p>El intérprete <b>vanilla</b> tiene tres casos: <code>true</code>, la conjunción <code>(A, B)</code> y una meta de usuario, que busca una cláusula y resuelve su cuerpo. Los predicados del sistema se ejecutan con <code>call/1</code>.</p>
<p>Al extenderlo obtienes profundidad de prueba, conteo de pasos, trazas o explicaciones (como el <code>como/2</code> del nivel 13).</p>`,
  programa:
`% meta.pl — Metaintérprete "vanilla" y extensiones
% resolver(Meta): ejecuta Meta interpretando las cláusulas del programa
resolver(true) :- !.
resolver((A, B)) :- !, resolver(A), resolver(B).
resolver((A ; B)) :- !, ( resolver(A) ; resolver(B) ).
resolver(G) :- predicate_property(G, built_in), !, call(G).
resolver(G) :- clause(G, Cuerpo), resolver(Cuerpo).

% profundidad(Meta, P): profundidad de la prueba
profundidad(true, 0) :- !.
profundidad((A, B), P) :- !,
    profundidad(A, PA), profundidad(B, PB), P is max(PA, PB).
profundidad(G, 0) :- predicate_property(G, built_in), !, call(G).
profundidad(G, P) :- clause(G, C), profundidad(C, P0), P is P0 + 1.

% programa objeto
progenitor(juan, pedro).
progenitor(pedro, luis).
progenitor(luis, ana).
ancestro(X, Y) :- progenitor(X, Y).
ancestro(X, Y) :- progenitor(X, Z), ancestro(Z, Y).

% Reto 3: define contar/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'clause(ancestro(X, Y), Cuerpo).', more: 1 },
    { q: 'resolver(ancestro(pedro, D)).', more: 1 },
    { q: 'profundidad(ancestro(pedro, ana), P).' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Usa <code>resolver/1</code> para encontrar todos los descendientes <code>D</code> de <code>juan</code>.',
      ref: 'resolver(ancestro(juan, D)).', usa: ['resolver'],
      pistas: ['Pasa la meta ancestro(juan, D) al metaintérprete.', 'resolver(ancestro(juan, D)).'] },
    { tipo: 'query', enunciado: '¿Qué profundidad <code>P</code> tiene la prueba de <code>ancestro(juan, ana)</code>?',
      ref: 'profundidad(ancestro(juan, ana), P).', usa: ['profundidad'],
      pistas: ['profundidad/2 ya existe.', 'profundidad(ancestro(juan, ana), P).'] },
    { tipo: 'program', enunciado: 'Define <code>contar(Meta, N)</code>: como <code>resolver/1</code>, pero <code>N</code> es cuántas metas de usuario se resolvieron.',
      check: 'contar(ancestro(juan, luis), 4), contar(progenitor(juan, pedro), 1), \\+ contar(ancestro(ana, juan), _)',
      pistas: ['Copia la forma de profundidad/2, pero suma en vez de tomar el máximo.',
               'contar(true, 0) :- !.\ncontar((A, B), N) :- !, contar(A, NA), contar(B, NB), N is NA + NB.\ncontar(G, 0) :- predicate_property(G, built_in), !, call(G).\ncontar(G, N) :- clause(G, C), contar(C, N0), N is N0 + 1.'] },
  ],
},
{
  id: '15', nivel: 15, titulo: 'DCG', tema: 'Gramáticas y un evaluador',
  fuente: 'Pereira & Warren (1980) · The Power of Prolog: DCGs',
  archivo: 'dcg',
  teoria: `
<p>Una <b>DCG</b> (<i>Definite Clause Grammar</i>) describe secuencias. <code>ab --> [a], ab, [b].</code> se traduce a un predicado con dos argumentos ocultos (la lista de entrada y el resto).</p>
<p>Se usa con <code>phrase(NoTerminal, Lista)</code>. Los terminales van entre corchetes. Una cadena <code>"+"</code> dentro del cuerpo de una DCG equivale a la lista de sus códigos.</p>
<p>Entre llaves <code>{ … }</code> va Prolog normal, por ejemplo para calcular con <code>is</code>.</p>
<p>El evaluador separa <b>expr</b> (+, −), <b>termino</b> (·, /) y <b>factor</b> (número o paréntesis); así respeta la precedencia sin ambigüedad. Escribe las expresiones sin espacios.</p>`,
  programa:
`% dcg.pl — Gramáticas de cláusulas definidas
% aⁿbⁿ
ab --> [].
ab --> [a], ab, [b].

% expresiones aritméticas con precedencia (sin espacios)
expr(V) --> termino(T), expr_resto(T, V).
expr_resto(Ac, V) --> "+", !, termino(T), { Ac1 is Ac + T }, expr_resto(Ac1, V).
expr_resto(Ac, V) --> "-", !, termino(T), { Ac1 is Ac - T }, expr_resto(Ac1, V).
expr_resto(V, V) --> [].
termino(V) --> factor(F), termino_resto(F, V).
termino_resto(Ac, V) --> "*", !, factor(F), { Ac1 is Ac * F }, termino_resto(Ac1, V).
termino_resto(Ac, V) --> "/", !, factor(F), { Ac1 is Ac / F }, termino_resto(Ac1, V).
termino_resto(V, V) --> [].
factor(V) --> "(", !, expr(V), ")".
factor(V) --> digitos(Ds), { Ds \\== [], number_codes(V, Ds) }.
digitos([D|T]) --> [D], { code_type(D, digit) }, !, digitos(T).
digitos([]) --> [].

% calcula(Texto, Valor)
calcula(Texto, V) :- string_codes(Texto, Cs), phrase(expr(V), Cs).

% Reto 3: define la DCG binario//0 aquí.
`,
  demo: [
    { consult: true },
    { q: 'phrase(ab, [a, a, b, b]).' },
    { q: 'phrase(ab, [a, b, b]).' },
    { c: 'La gramática también genera:' },
    { q: 'phrase(ab, L).', more: 2 },
    { q: 'calcula("2*(3+4)-5", V).' },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Cuánto vale <code>"2+3*(4-1)"</code> con <code>calcula/2</code>?',
      ref: 'calcula("2+3*(4-1)", V).', usa: ['calcula'],
      pistas: ['El texto va entre comillas dobles.', 'calcula("2+3*(4-1)", V).'] },
    { tipo: 'query', enunciado: '¿Qué lista <code>L</code> de longitud 6 genera <code>ab</code>?',
      ref: 'length(L, 6), phrase(ab, L).', usa: ['ab'],
      pistas: ['Fija la longitud con length/2 y luego llama a phrase/2.', 'length(L, 6), phrase(ab, L).'] },
    { tipo: 'program', enunciado: 'Define la DCG <code>binario</code>: acepta cadenas <b>no vacías</b> de <code>0</code> y <code>1</code>. Prueba con <code>string_codes("1011", C), phrase(binario, C)</code>.',
      check: 'string_codes("1011", C), phrase(binario, C), string_codes("", E), \\+ phrase(binario, E), string_codes("12", X), \\+ phrase(binario, X)',
      pistas: ['Un binario es un bit, o un bit seguido de un binario.',
               'binario --> bit.\nbinario --> bit, binario.\nbit --> "0".\nbit --> "1".'] },
  ],
},
{
  id: '16', nivel: 16, titulo: 'CLP(FD)', tema: 'SEND+MORE, Sudoku y horarios',
  fuente: 'The Power of Prolog: CLP(FD) (Triska) · manual SWI-Prolog',
  archivo: 'clpfd',
  teoria: `
<p><code>library(clpfd)</code> razona con <b>restricciones</b> sobre enteros: <code>#=</code>, <code>#\\=</code>, <code>#&lt;</code>… funcionan en <b>todas direcciones</b>, a diferencia de <code>is</code>.</p>
<p><code>Vs ins 0..9</code> fija dominios. <code>all_different/1</code> y <code>all_distinct/1</code> obligan a que los valores sean distintos. La <b>propagación</b> poda dominios y <code>label/1</code> busca valores concretos.</p>
<p>Patrón: <b>1)</b> declarar dominios, <b>2)</b> poner restricciones, <b>3)</b> etiquetar. Sudoku, criptoaritmética y horarios siguen este patrón.</p>
<p><code>serialized(Inicios, Duraciones)</code> impide que dos tareas se traslapen.</p>`,
  programa:
`% clpfd.pl — Programación con restricciones sobre dominios finitos
:- use_module(library(clpfd)).

% SEND + MORE = MONEY
puzzle([S,E,N,D] + [M,O,R,E] = [M,O,N,E,Y]) :-
    Vs = [S,E,N,D,M,O,R,Y],
    Vs ins 0..9,
    all_different(Vs),
    S #\\= 0, M #\\= 0,
              1000*S + 100*E + 10*N + D
            + 1000*M + 100*O + 10*R + E
    #= 10000*M + 1000*O + 100*N + 10*E + Y,
    label(Vs).

% sudoku(Filas): 9 filas de 9 casillas
sudoku(Filas) :-
    length(Filas, 9), maplist(same_length(Filas), Filas),
    append(Filas, Vs), Vs ins 1..9,
    maplist(all_distinct, Filas),
    transpose(Filas, Columnas), maplist(all_distinct, Columnas),
    Filas = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
    bloques(As, Bs, Cs), bloques(Ds, Es, Fs), bloques(Gs, Hs, Is).

bloques([], [], []).
bloques([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
    all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
    bloques(Ns1, Ns2, Ns3).

problema(1, [[5,3,_,_,7,_,_,_,_],
             [6,_,_,1,9,5,_,_,_],
             [_,9,8,_,_,_,_,6,_],
             [8,_,_,_,6,_,_,_,3],
             [4,_,_,8,_,3,_,_,1],
             [7,_,_,_,2,_,_,_,6],
             [_,6,_,_,_,_,2,8,_],
             [_,_,_,4,1,9,_,_,5],
             [_,_,_,_,8,_,_,7,9]]).

% Reto 3: define horario/1 aquí.
`,
  demo: [
    { consult: true },
    { c: 'Las restricciones funcionan en ambas direcciones:' },
    { q: 'X #= 3 + Y, Y #= 2.' },
    { q: 'X + 2 #= 7.' },
    { q: 'X in 1..5, X #> 3, label([X]).', more: 1 },
    { q: 'puzzle(P).' },
    { q: 'problema(1, F), sudoku(F), maplist(label, F), F = [Fila1|_].' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Resuelve SEND+MORE=MONEY y obtén el valor de cada letra <code>S, E, N, D, M, O, R, Y</code>.',
      ref: 'puzzle([S,E,N,D] + [M,O,R,E] = [M,O,N,E,Y]).', usa: ['puzzle'],
      pistas: ['Pasa a puzzle/1 el patrón con las letras como variables.', 'puzzle([S,E,N,D] + [M,O,R,E] = [M,O,N,E,Y]).'] },
    { tipo: 'query', enunciado: 'Resuelve el sudoku <code>problema(1, F)</code> y obtén su <b>última</b> fila <code>U</code>.',
      ref: 'problema(1, _F), sudoku(_F), last(_F, U).', usa: ['sudoku'],
      pistas: ['last/2 da el último elemento de una lista.', 'problema(1, F), sudoku(F), last(F, U).'] },
    { tipo: 'program', enunciado: 'Define <code>horario([A, B, C])</code>: tareas de 3, 2 y 1 horas que inician entre 0 y 6, sin traslaparse, y <code>A</code> termina antes de que empiece <code>C</code>.',
      check: 'horario([A,B,C]), integer(A), A + 3 =< C, (A + 3 =< B ; B + 2 =< A), (B + 2 =< C ; C + 1 =< B), C =< 6',
      pistas: ['Dominios con ins, no traslape con serialized/2, la precedencia con #=< y al final label/1.',
               'horario([A, B, C]) :-\n    [A, B, C] ins 0..6,\n    serialized([A, B, C], [3, 2, 1]),\n    A + 3 #=< C,\n    label([A, B, C]).'] },
  ],
},
{
  id: '17', nivel: 17, titulo: 'Módulos + plunit', tema: 'Una pila con pruebas',
  fuente: 'Manual SWI-Prolog: módulos (cap. 6) y plunit',
  archivo: 'modulos',
  teoria: `
<p>Un <b>módulo</b> empieza con <code>:- module(Nombre, [pred/aridad, …])</code>. Solo lo exportado se ve desde fuera; lo demás es privado, aunque se puede llamar calificado: <code>pila:interno(X)</code>.</p>
<p><code>:- export(pred/N).</code> agrega exportaciones después de la cabecera. <code>use_module/1</code> carga un módulo e importa sus exportaciones.</p>
<p><b>plunit</b>: las pruebas van entre <code>:- begin_tests(Unidad).</code> y <code>:- end_tests(Unidad).</code>. Cada <code>test(Nombre) :- Cuerpo.</code> debe tener éxito; con <code>[fail]</code> se espera que falle y con <code>[true(X == v)]</code> se comprueba un valor.</p>
<p><code>run_tests.</code> ejecuta todo. En local: <code>swipl -g run_tests -t halt archivo.pl</code>.</p>`,
  programa:
`% modulos.pl — Módulos y pruebas unitarias con plunit
:- module(pila, [vacia/1, apilar/3, desapilar/3, tope/2]).
:- use_module(library(plunit)).

% Pila representada como lista
vacia([]).
apilar(X, P, [X|P]).
desapilar(X, [X|P], P).
tope([X|_], X).

% auxiliar privado: no se exporta
interno(hola).

:- begin_tests(pila).
test(apilar) :- vacia(P0), apilar(a, P0, P1), tope(P1, a).
test(desapilar, [true(X-P == b-[a])]) :- desapilar(X, [b, a], P).
test(tope_vacio, [fail]) :- tope([], _).
:- end_tests(pila).

% Reto 2: exporta y define tamanio/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'apilar(x, [], P), apilar(y, P, P2), tope(P2, T).' },
    { c: 'interno/1 es privado; calificado con el módulo sí se puede llamar:' },
    { q: 'pila:interno(X).' },
    { q: 'run_tests.' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Ejecuta las pruebas unitarias del módulo.',
      ref: 'run_tests.', usa: ['run_tests'],
      pistas: ['Un solo predicado sin argumentos.', 'run_tests.'] },
    { tipo: 'program', enunciado: 'Agrega <code>tamanio(P, N)</code> (número de elementos de la pila) y <b>expórtalo</b> para que se pueda llamar sin calificar.',
      check: 'tamanio([a, b, c], 3), tamanio([], 0)',
      pistas: ['Sin exportar, tamanio/2 queda privado del módulo pila. Usa la directiva :- export(tamanio/2).',
               ':- export(tamanio/2).\ntamanio(P, N) :- length(P, N).'] },
    { tipo: 'query', enunciado: 'Llama al predicado privado <code>interno/1</code> calificándolo con su módulo.',
      ref: 'pila:interno(X).', usa: ['pila', 'interno'],
      pistas: ['Sintaxis Modulo:Meta.', 'pila:interno(X).'] },
  ],
},
{
  id: '18', nivel: 18, titulo: 'Servidor web', tema: 'API REST', local: true,
  fuente: 'Manual SWI-Prolog: library(http/http_server) · Wielemaker, "SWI-Prolog and the Web"',
  archivo: 'api',
  teoria: `
<p><b>LOCAL:</b> el servidor HTTP no corre en el navegador. Aquí practicas la <b>lógica de rutas</b> como predicados puros, la misma que el servidor real llama en cada petición.</p>
<p>Cada <code>ruta(Metodo, Ruta, Params, Codigo, Respuesta)</code> describe un endpoint. Las respuestas son <b>dicts</b> (<code>_{id: 1, titulo: "x"}</code>), que se convierten a JSON directamente.</p>
<p>Servidor real (guárdalo como <code>servidor.pl</code> junto a <code>api.pl</code> y corre <code>swipl servidor.pl</code>):</p>
<pre>:- use_module(library(http/http_server)).
:- use_module(library(http/http_json)).
:- consult(api).
:- http_handler(root(.), atender_http, [prefix]).

atender_http(Req) :-
    memberchk(method(M), Req), memberchk(path(R), Req),
    ( M == post -> http_read_json_dict(Req, P) ; P = _{} ),
    atender(M, R, P, Codigo, Resp),
    reply_json_dict(Resp, [status(Codigo)]).

:- initialization(http_server([port(8080)])).</pre>
<p>Prueba: <code>curl localhost:8080/tareas</code></p>`,
  programa:
`% api.pl — API REST de tareas: lógica de rutas
:- dynamic tarea/3.
:- discontiguous ruta/5.
tarea(1, "Estudiar Prolog", false).
tarea(2, "Hacer los retos", true).

% ruta(Metodo, Ruta, Params, Codigo, Respuesta)
ruta(get, '/tareas', _, 200, Ts) :-
    findall(_{id: I, titulo: T, hecha: H}, tarea(I, T, H), Ts).
ruta(get, '/tareas/pendientes', _, 200, Ts) :-
    findall(_{id: I, titulo: T}, tarea(I, T, false), Ts).
ruta(post, '/tareas', P, 201, _{id: Id}) :-
    get_dict(titulo, P, T),
    aggregate_all(max(I), tarea(I, _, _), Max), Id is Max + 1,
    assertz(tarea(Id, T, false)).

% atender(M, R, P, Codigo, Resp): primera ruta que aplica; si ninguna, 404
atender(M, R, P, C, Resp) :-
    (   ruta(M, R, P, C0, Resp0)
    ->  C = C0, Resp = Resp0
    ;   C = 404, Resp = _{error: "no encontrado"}
    ).

% Reto 2: agrega la ruta DELETE aquí.
`,
  demo: [
    { consult: true },
    { q: "atender(get, '/tareas', _{}, C, R)." },
    { q: "atender(post, '/tareas', _{titulo: \"Leer LPN\"}, C, R)." },
    { q: "atender(get, '/tareas', _{}, C, R)." },
  ],
  retos: [
    { tipo: 'query', enunciado: '¿Qué responde <code>GET /tareas/pendientes</code>? Obtén código <code>C</code> y respuesta <code>R</code> con <code>atender/5</code> (params <code>_{}</code>).',
      ref: "atender(get, '/tareas/pendientes', _{}, C, R).", usa: ['atender'],
      pistas: ['La ruta es un átomo entre comillas simples.', "atender(get, '/tareas/pendientes', _{}, C, R)."] },
    { tipo: 'program', enunciado: 'Agrega <code>DELETE /tareas</code> con params <code>_{id: N}</code>: borra la tarea y responde <code>200</code> con <code>_{borrada: N}</code>.',
      check: "atender(delete, '/tareas', _{id: 1}, 200, R), get_dict(borrada, R, 1), \\+ tarea(1, _, _), atender(delete, '/tareas', _{id: 99}, 404, _)",
      pistas: ['Una cláusula nueva de ruta/5 con get_dict/3 y retract/1. Si la tarea no existe, retract falla y atender responde 404.',
               "ruta(delete, '/tareas', P, 200, _{borrada: Id}) :-\n    get_dict(id, P, Id),\n    retract(tarea(Id, _, _))."] },
    { tipo: 'query', enunciado: '¿Qué código <code>C</code> devuelve una ruta inexistente, como <code>GET /usuarios</code>?',
      ref: "atender(get, '/usuarios', _{}, C, _).", usa: ['usuarios'],
      pistas: ['Pide solo el código.', "atender(get, '/usuarios', _{}, C, _)."] },
  ],
},
{
  id: '19', nivel: 19, titulo: 'Janus', tema: 'Prolog ↔ Python', local: true,
  fuente: 'Manual SWI-Prolog: library(janus) · paquete janus-swi (PyPI)',
  archivo: 'datos',
  teoria: `
<p><b>LOCAL:</b> Janus (SWI-Prolog ≥ 9.1.12) une Prolog y Python en un mismo proceso. No corre en el navegador; aquí trabajas con los mismos datos como hechos.</p>
<p>Desde Prolog: <code>py_call(Modulo:Funcion(Args), Resultado)</code>. Las listas y dicts de Python se convierten en listas y dicts de Prolog.</p>
<pre>?- py_call(pandas:read_csv('alumnos.csv'), DF),
   py_call(DF:to_dict(orient=records), Filas).</pre>
<p>Desde Python (<code>pip install janus-swi</code>):</p>
<pre>import janus_swi as janus
janus.consult("datos.pl")
for s in janus.query("promedio_carrera(C, P)"):
    print(s["C"], s["P"])</pre>
<p>Equivalencias: <code>groupby().mean()</code> → <code>aggregate_all</code>; un filtro → <code>findall</code> con condición.</p>`,
  programa:
`% datos.pl — Análisis de datos (en local, las filas llegan de pandas vía Janus)
% fila(Nombre, Carrera, Promedio)
fila(ana,   sistemas,    92).
fila(beto,  sistemas,    78).
fila(carla, industrial,  85).
fila(diego, industrial,  64).
fila(elena, electronica, 88).
fila(fer,   sistemas,    71).

% promedio_carrera(C, P): df.groupby('carrera').promedio.mean()
promedio_carrera(C, P) :-
    setof(C0, N^X^fila(N, C0, X), Cs), member(C, Cs),
    aggregate_all(bag(X), fila(_, C, X), Xs),
    sum_list(Xs, S), length(Xs, L), P is S / L.

% reprobados(Ns): df[df.promedio < 70].nombre
reprobados(Ns) :- findall(N, (fila(N, _, X), X < 70), Ns).

% Reto 3: define aprobados_por_carrera/2 aquí.
`,
  demo: [
    { consult: true },
    { q: 'fila(N, sistemas, P).', more: 2 },
    { q: 'reprobados(R).' },
    { q: 'promedio_carrera(C, P).', more: 2 },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Obtén el promedio <code>P</code> de cada carrera <code>C</code> (como <code>groupby().mean()</code>).',
      ref: 'promedio_carrera(C, P).', usa: ['promedio_carrera'],
      pistas: ['Ya existe promedio_carrera/2; pide todas las soluciones.', 'promedio_carrera(C, P).'] },
    { tipo: 'query', enunciado: '¿Quién tiene el promedio más alto? Obtén su promedio <code>P</code> y su nombre <code>Nombre</code>.',
      ref: 'aggregate_all(max(X, N), fila(N, _, X), max(P, Nombre)).', usa: ['fila'],
      pistas: ['aggregate_all(max(Valor, Testigo), Meta, max(V, T)) devuelve el máximo y quién lo tiene.', 'aggregate_all(max(X, N), fila(N, _, X), max(P, Nombre)).'] },
    { tipo: 'program', enunciado: 'Define <code>aprobados_por_carrera(C, N)</code>: cuántos alumnos de la carrera <code>C</code> tienen 70 o más.',
      check: 'aprobados_por_carrera(sistemas, 3), aprobados_por_carrera(industrial, 1), aprobados_por_carrera(electronica, 1)',
      pistas: ['Cuenta con aggregate_all(count, …) filtrando por carrera y promedio.',
               'aprobados_por_carrera(C, N) :-\n    aggregate_all(count, (fila(_, C, X), X >= 70), N).'] },
  ],
},
{
  id: '20', nivel: 20, titulo: 'Integrador', tema: 'Sistema experto + API', local: true,
  fuente: 'Niveles 12, 13 y 18 combinados',
  archivo: 'integrador',
  teoria: `
<p><b>LOCAL:</b> proyecto final. Un <b>sistema experto</b> de fallas de computadora, expuesto como API (<code>POST /diagnostico</code>) y consumido desde Python.</p>
<p><b>Certeza</b>: porcentaje de los síntomas de la falla que el usuario reporta. <code>mejor/3</code> elige el diagnóstico con mayor certeza usando <code>aggregate_all(max(C, D), …)</code>.</p>
<p><code>api/2</code> recibe el dict que llegaría como JSON, con los síntomas como strings, y devuelve el dict de respuesta.</p>
<p>En local, conecta <code>api/2</code> al servidor del nivel 18:</p>
<pre>atender_http(Req) :-
    http_read_json_dict(Req, P),
    api(P, Resp), reply_json_dict(Resp).</pre>
<p>Y prueba desde Python: <code>requests.post(url, json={"sintomas": ["enciende", "lento"]}).json()</code></p>`,
  programa:
`% integrador.pl — Sistema experto de fallas + capa API
:- discontiguous falla/2.

% falla(Diagnostico, Sintomas)
falla(fuente_poder,       [no_enciende, sin_luces]).
falla(memoria_ram,        [enciende, pitidos, sin_video]).
falla(disco_duro,         [enciende, lento, ruidos]).
falla(sobrecalentamiento, [enciende, se_apaga, ventilador_ruidoso]).
falla(virus,              [enciende, lento, ventanas_extranas]).

% diagnostico(Ss, D, Certeza): % de los síntomas de D presentes en Ss
diagnostico(Ss, D, Certeza) :-
    falla(D, Req),
    intersection(Req, Ss, Com),
    length(Com, NC), NC > 0, length(Req, NR),
    Certeza is round(100 * NC / NR).

% mejor(Ss, D, C): diagnóstico de mayor certeza
mejor(Ss, D, C) :-
    aggregate_all(max(C0, D0), diagnostico(Ss, D0, C0), max(C, D)).

% api(Peticion, Respuesta): lo que respondería POST /diagnostico
api(_{sintomas: Ss0}, _{diagnostico: D, certeza: C}) :-
    maplist([A, S]>>atom_string(A, S), Ss, Ss0),
    mejor(Ss, D, C).

% Reto 3: agrega la falla de pantalla aquí.
`,
  demo: [
    { consult: true },
    { q: 'diagnostico([enciende, lento], D, C).', more: 2 },
    { q: 'mejor([enciende, se_apaga], D, C).' },
    { c: 'Así llegaría una petición JSON al servidor:' },
    { q: 'api(_{sintomas: ["enciende", "pitidos"]}, R).' },
  ],
  retos: [
    { tipo: 'query', enunciado: 'Diagnostica <code>[enciende, lento, ruidos]</code> con <code>mejor/3</code>: obtén falla <code>D</code> y certeza <code>C</code>.',
      ref: 'mejor([enciende, lento, ruidos], D, C).', usa: ['mejor'],
      pistas: ['La lista de síntomas va como primer argumento.', 'mejor([enciende, lento, ruidos], D, C).'] },
    { tipo: 'query', enunciado: 'Llama a <code>api/2</code> como lo haría el servidor, con síntomas <code>["no_enciende"]</code>. Obtén la respuesta <code>R</code>.',
      ref: 'api(_{sintomas: ["no_enciende"]}, R).', usa: ['api'],
      pistas: ['La petición es un dict con la clave sintomas.', 'api(_{sintomas: ["no_enciende"]}, R).'] },
    { tipo: 'program', enunciado: 'Agrega la falla <code>pantalla</code> con síntomas <code>[enciende, sin_video, sin_luz_fondo]</code>.',
      check: 'mejor([enciende, sin_video, sin_luz_fondo], pantalla, 100), mejor([enciende, pitidos, sin_video], memoria_ram, 100)',
      pistas: ['Un hecho nuevo de falla/2.', 'falla(pantalla, [enciende, sin_video, sin_luz_fondo]).'] },
  ],
},
];
