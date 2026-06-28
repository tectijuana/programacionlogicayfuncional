(* ============================================================
   Demo OCaml — Semana 2, Tema 1.2
   "El lenguaje detrás de las herramientas de Meta"

   OCaml no es el lenguaje que aprenderás a fondo en este curso —
   para eso tenemos Erlang, Haskell, Clojure y Prolog.
   Este demo existe por UNA razón: entender POR QUÉ Meta eligió
   un lenguaje funcional tipado para construir las herramientas
   que analizan 100+ millones de líneas de código al día.

   Ejecutar: ocaml ocaml_demo.ml
   Instalar: brew install ocaml   (macOS)
             sudo apt install ocaml  (Linux)
   ============================================================ *)


(* ============================================================
   1. INFERENCIA DE TIPOS
   El compilador deduce el tipo sin que lo declares.
   Igual que Haskell. Diferente de Java.
   ============================================================ *)

let suma a b = a + b
(* OCaml infiere: val suma : int -> int -> int *)
(* No necesitas escribir "int suma(int a, int b)" *)

let concatenar a b = a ^ b
(* OCaml infiere: val concatenar : string -> string -> string *)
(* El mismo operador '+' para ints y '^' para strings — sin sobrecarga *)

let () =
  Printf.printf "\n=== 1. Inferencia de tipos ===\n";
  Printf.printf "suma 3 4 = %d\n" (suma 3 4);
  Printf.printf "concatenar \"CURP\" \"_BC\" = %s\n" (concatenar "CURP" "_BC")


(* ============================================================
   2. OPTION — el null seguro
   En Java: NullPointerException en runtime.
   En OCaml: el compilador te OBLIGA a manejar el caso None.
   Esta es la razón #1 por la que Flow (verificador de tipos
   de JavaScript) está escrito en OCaml — el lenguaje mismo
   garantiza que el analizador no tiene null desnudos.
   ============================================================ *)

(* Busca un alumno por matrícula — puede no existir *)
let buscar_alumno matricula alumnos =
  List.find_opt (fun (m, _) -> m = matricula) alumnos

(* El compilador EXIGE manejar ambos casos *)
let mostrar_alumno resultado =
  match resultado with
  | None          -> "Alumno no encontrado"
  | Some (_, nom) -> "Encontrado: " ^ nom

let () =
  Printf.printf "\n=== 2. Option — null seguro ===\n";
  let base = [("C2150001", "García Ramírez Carlos");
              ("C2150002", "López Mendoza Ana");
              ("C2150003", "Ramos Torres Luis")] in
  Printf.printf "%s\n" (mostrar_alumno (buscar_alumno "C2150002" base));
  Printf.printf "%s\n" (mostrar_alumno (buscar_alumno "C9999999" base))
  (* Sin el match sobre None, el compilador no compila — eso es Flow *)


(* ============================================================
   3. TIPOS ALGEBRAICOS + PATTERN MATCHING EXHAUSTIVO
   Aquí está el secreto de por qué OCaml es ideal para compiladores
   e inferidores de tipos como Flow, Hack e Infer.

   Un AST (Abstract Syntax Tree) — la representación interna
   de cualquier programa — se modela naturalmente como tipo algebraico.
   ============================================================ *)

(* Tipo algebraico: un mini-lenguaje de expresiones *)
type expr =
  | Num    of float
  | Suma   of expr * expr
  | Resta  of expr * expr
  | Mult   of expr * expr
  | Div    of expr * expr
  | Neg    of expr

(* Evaluador: pattern matching sobre el AST *)
(* Si agregamos un constructor al tipo y olvidamos un caso aquí,
   el COMPILADOR avisa con "Warning: this pattern-matching is not exhaustive"
   — exactamente lo que Flow hace con tu JavaScript *)
let rec evaluar = function
  | Num n        -> n
  | Suma (a, b)  -> evaluar a +. evaluar b
  | Resta (a, b) -> evaluar a -. evaluar b
  | Mult (a, b)  -> evaluar a *. evaluar b
  | Div  (a, b)  -> evaluar a /. evaluar b
  | Neg  a       -> -. (evaluar a)

(* Impresor del AST — misma técnica, diferente propósito *)
let rec imprimir = function
  | Num n        -> string_of_float n
  | Suma (a, b)  -> "(" ^ imprimir a ^ " + " ^ imprimir b ^ ")"
  | Resta (a, b) -> "(" ^ imprimir a ^ " - " ^ imprimir b ^ ")"
  | Mult (a, b)  -> "(" ^ imprimir a ^ " * " ^ imprimir b ^ ")"
  | Div  (a, b)  -> "(" ^ imprimir a ^ " / " ^ imprimir b ^ ")"
  | Neg  a       -> "(-" ^ imprimir a ^ ")"

let () =
  Printf.printf "\n=== 3. AST + Pattern matching exhaustivo ===\n";
  (* Representa: (3 + 4) * -(10 - 2) *)
  let expr = Mult (
    Suma (Num 3.0, Num 4.0),
    Neg (Resta (Num 10.0, Num 2.0))
  ) in
  Printf.printf "Expresión: %s\n" (imprimir expr);
  Printf.printf "Resultado: %.1f\n" (evaluar expr)
  (* Este mismo patrón — tipo algebraico + pattern matching recursivo —
     es exactamente cómo Flow analiza el árbol de tu código JavaScript *)


(* ============================================================
   4. MÓDULOS — el sistema que Hack usa para escalar
   OCaml tiene el sistema de módulos más poderoso de cualquier
   lenguaje de propósito general. Hack usa esto internamente
   para separar el análisis de tipos del análisis de flujo.
   ============================================================ *)

module ValidadorCURP = struct
  (* Interfaz implícita — en .mli sería la interfaz pública *)

  let longitud_valida curp = String.length curp = 18

  let sexo_valido curp =
    match String.get curp 10 with
    | 'H' | 'M' -> true
    | _          -> false

  let validar curp =
    if not (longitud_valida curp) then Error "Longitud incorrecta"
    else if not (sexo_valido curp)  then Error "Sexo inválido en posición 10"
    else Ok curp
end

let () =
  Printf.printf "\n=== 4. Módulos — encapsulación ===\n";
  let curps = ["ROSO850312HBCNLS09"; "LOMA920615MBCPZN04"; "INVALIDO"] in
  List.iter (fun c ->
    match ValidadorCURP.validar c with
    | Ok _     -> Printf.printf "  %-20s → válida\n" c
    | Error e  -> Printf.printf "  %-20s → error: %s\n" c e
  ) curps


(* ============================================================
   5. LA CONEXIÓN DIRECTA CON EL CURSO
   Estas ideas en OCaml las verás de nuevo en:
   ============================================================ *)

let () =
  Printf.printf "\n=== 5. Mapa OCaml → lenguajes del curso ===\n\n";

  let conexiones = [
    ("Option (None | Some)", "Maybe (Nothing | Just)  en Haskell  — Tema 2.3");
    ("Pattern matching",     "Pattern matching         en Erlang   — Tema 2.1");
    ("Tipo algebraico",      "Algebraic data types     en Haskell  — Tema 2.3");
    ("Módulos + firmas",     "Módulos Prolog            en Prolog   — Tema 4.1");
    ("Recursión estructural","Inducción estructural     en Haskell  — Tema 2.3");
    ("Inmutabilidad",        "Vars inmutables           en Erlang   — Tema 2.1");
  ] in

  List.iter (fun (ocaml, curso) ->
    Printf.printf "  OCaml: %-30s → %s\n" ocaml curso
  ) conexiones;

  Printf.printf "\n";
  Printf.printf "  Boris Cherny (creador de Claude Code)\n";
  Printf.printf "  trabajó 5 años en Meta/Facebook con Flow y Hack —\n";
  Printf.printf "  ambos escritos en OCaml.\n";
  Printf.printf "\n";
  Printf.printf "  La herramienta que estás usando para programar hoy\n";
  Printf.printf "  tiene ADN funcional directo.\n\n"
