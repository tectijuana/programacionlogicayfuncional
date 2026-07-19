-- =====================================================================
-- Programa:    recursion.hs
-- Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
-- Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
-- Actividad:   Tema 2.3 — Recursión e inmutabilidad
-- Fecha:       2026-07-18
-- Descripción: Recursión de cola, Maybe/Either y tipos algebraicos en Haskell
-- IA:          Generado con Claude Code, verificado y modificado por el docente
-- =====================================================================
-- Tema 2.3 — Recursión y estructuras de datos inmutables
-- Haskell: tipos algebraicos, Maybe, Either, recursión de cola
-- TecNM ISC — Programación Lógica y Funcional

module Main where

import Data.List (find, intercalate)
import Data.Char (isDigit, isAlpha, isUpper)

-- ============================================================
-- Tipos algebraicos de dominio
-- ============================================================

data Alumno = Alumno
  { matricula :: String
  , nombre    :: String
  , promedio  :: Double
  , unidad    :: String
  } deriving (Show, Eq)

data ErrorValidacion
  = MatriculaInvalida String
  | PromedioFueraDeRango Double
  | NombreVacio
  deriving (Show, Eq)

-- ============================================================
-- Recursión de cola — factorial con acumulador
-- ============================================================

-- factorial :: Integer -> Integer
-- Tail-recursive: el compilador GHC optimiza esto a un loop.
-- NUNCA crece la pila de llamadas más allá de O(1).
factorial :: Integer -> Integer
factorial n
  | n < 0    = error "factorial no definido para negativos"
  | otherwise = go n 1
  where
    go :: Integer -> Integer -> Integer
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)  -- llamada de cola

-- ============================================================
-- Maybe — búsqueda segura sin excepciones
-- ============================================================

-- buscarAlumno :: String -> [Alumno] -> Maybe Alumno
-- NUNCA lanza excepción. Retorna Nothing si no existe.
-- El tipo Maybe obliga al llamador a manejar el caso vacío.
buscarAlumno :: String -> [Alumno] -> Maybe Alumno
buscarAlumno mat = find (\a -> matricula a == mat)

-- buscarPorNombre :: String -> [Alumno] -> [Alumno]
-- Búsqueda parcial en nombre — puede retornar múltiples resultados.
buscarPorNombre :: String -> [Alumno] -> [Alumno]
buscarPorNombre texto = filter (\a -> texto `esSubcadena` nombre a)
  where
    esSubcadena sub str = any (isPrefijo sub) (suffixes str)
    isPrefijo []     _      = True
    isPrefijo _      []     = False
    isPrefijo (x:xs) (y:ys) = x == y && isPrefijo xs ys
    suffixes []     = [[]]
    suffixes xs@(_:rest) = xs : suffixes rest

-- ============================================================
-- Either — operaciones que pueden fallar con mensaje de error
-- ============================================================

-- promedioGrupo :: [Alumno] -> Either String Double
-- Left si la lista está vacía (error con descripción).
-- Right con el promedio calculado.
promedioGrupo :: [Alumno] -> Either String Double
promedioGrupo [] = Left "No se puede calcular promedio de grupo vacío"
promedioGrupo xs = Right $ sumaPromedios xs / fromIntegral (length xs)
  where
    sumaPromedios :: [Alumno] -> Double
    sumaPromedios []     = 0.0
    sumaPromedios (a:as) = promedio a + sumaPromedios as

-- mejorAlumno :: [Alumno] -> Either String Alumno
-- Retorna el alumno con mayor promedio.
mejorAlumno :: [Alumno] -> Either String Alumno
mejorAlumno [] = Left "Lista vacía — no hay mejor alumno"
mejorAlumno (x:xs) = Right $ go xs x
  where
    go []     mejor = mejor
    go (a:as) mejor
      | promedio a > promedio mejor = go as a
      | otherwise                   = go as mejor

-- ============================================================
-- Validación de matrícula TecNM
-- ============================================================

-- validarMatricula :: String -> Bool
-- Formato TecNM: "C" + 2 dígitos año + 5 dígitos número
-- Ejemplo válido: "C2150001", "C2350010"
validarMatricula :: String -> Bool
validarMatricula mat = case mat of
  ('C' : a1 : a2 : d1 : d2 : d3 : d4 : d5 : []) ->
    isDigit a1 && isDigit a2 &&
    isDigit d1 && isDigit d2 && isDigit d3 &&
    isDigit d4 && isDigit d5
  _ -> False

-- validarAlumno :: Alumno -> Either ErrorValidacion Alumno
-- Valida todos los campos, retorna el error más específico.
validarAlumno :: Alumno -> Either ErrorValidacion Alumno
validarAlumno a
  | null (nombre a)              = Left NombreVacio
  | not (validarMatricula (matricula a)) =
      Left (MatriculaInvalida (matricula a))
  | promedio a < 0 || promedio a > 10.0 =
      Left (PromedioFueraDeRango (promedio a))
  | otherwise = Right a

-- ============================================================
-- Datos de ejemplo
-- ============================================================

alumnosTecNM :: [Alumno]
alumnosTecNM =
  [ Alumno "C2150001" "García Ramírez, Carlos"   8.5 "Tijuana"
  , Alumno "C2250002" "López Mendoza, Ana"        5.8 "Mexicali"
  , Alumno "C2150003" "Ramos Torres, Luis"        9.1 "Tijuana"
  , Alumno "C2350004" "Hernández Cruz, María"     7.3 "Ensenada"
  , Alumno "C2250005" "Martínez Soto, José"       6.0 "Mexicali"
  , Alumno "C2150006" "Pérez Flores, Sandra"      4.5 "Tijuana"
  , Alumno "C2350007" "Jiménez Ruiz, Diego"       9.8 "Ensenada"
  , Alumno "C2250008" "Morales Vega, Patricia"    7.0 "Mexicali"
  , Alumno "C2150009" "Reyes Castillo, Fernando"  8.0 "Tijuana"
  , Alumno "C2350010" "Vargas Núñez, Claudia"     5.5 "Ensenada"
  ]

alumnoInvalido :: Alumno
alumnoInvalido = Alumno "X999" "" 15.0 "Ninguna"

-- ============================================================
-- Programa principal
-- ============================================================

main :: IO ()
main = do
  putStrLn "\n=== Haskell: Recursión y Tipos Algebraicos — TecNM ===\n"

  putStrLn "--- factorial (tail-recursive) ---"
  putStrLn $ "10!  = " ++ show (factorial 10)
  putStrLn $ "20!  = " ++ show (factorial 20)
  putStrLn $ "100! = " ++ show (factorial 100)

  putStrLn "\n--- buscarAlumno (retorna Maybe) ---"
  case buscarAlumno "C2350007" alumnosTecNM of
    Nothing -> putStrLn "Matrícula no encontrada"
    Just a  -> putStrLn $ "Encontrado: " ++ nombre a ++
                          " (promedio: " ++ show (promedio a) ++ ")"

  case buscarAlumno "C9999999" alumnosTecNM of
    Nothing -> putStrLn "C9999999: no existe en el sistema"
    Just _  -> putStrLn "Encontrado (inesperado)"

  putStrLn "\n--- promedioGrupo (retorna Either) ---"
  case promedioGrupo alumnosTecNM of
    Left err -> putStrLn $ "Error: " ++ err
    Right p  -> putStrLn $ "Promedio del grupo: " ++ show p

  case promedioGrupo [] of
    Left err -> putStrLn $ "Lista vacía → " ++ err
    Right _  -> putStrLn "Resultado inesperado"

  putStrLn "\n--- mejorAlumno ---"
  case mejorAlumno alumnosTecNM of
    Left err -> putStrLn $ "Error: " ++ err
    Right a  -> putStrLn $ "Mejor alumno: " ++ nombre a ++
                           " con " ++ show (promedio a)

  putStrLn "\n--- validarMatricula ---"
  mapM_ (\m -> putStrLn $ m ++ ": " ++ show (validarMatricula m))
    ["C2150001", "C2350010", "X999", "C215001", "c2150001"]

  putStrLn "\n--- validarAlumno (Either ErrorValidacion Alumno) ---"
  case validarAlumno alumnoInvalido of
    Left err -> putStrLn $ "Alumno inválido: " ++ show err
    Right _  -> putStrLn "Válido (inesperado)"

  -- pattern matching en vez de `head` (función parcial — estándar del curso)
  case alumnosTecNM of
    []          -> putStrLn "Sin alumnos de ejemplo"
    (primero:_) -> case validarAlumno primero of
      Left _  -> putStrLn "Inválido (inesperado)"
      Right a -> putStrLn $ "Alumno válido: " ++ nombre a
