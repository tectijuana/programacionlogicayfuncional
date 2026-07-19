-- =====================================================================
-- Programa:    induccion_estructural.hs
-- Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
-- Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
-- Actividad:   Tema 2.3 — Recursión e inmutabilidad
-- Fecha:       2026-07-18
-- Descripción: Inducción estructural sobre listas y árboles en Haskell
-- IA:          Generado con Claude Code, verificado y modificado por el docente
-- =====================================================================
module InduccionEstructural where

-- Las dos implementaciones que vamos a probar equivalentes

reverseNaive :: [a] -> [a]
reverseNaive []     = []
reverseNaive (x:xs) = reverseNaive xs ++ [x]

reverseAcc :: [a] -> [a] -> [a]
reverseAcc []     acc = acc
reverseAcc (x:xs) acc = reverseAcc xs (x : acc)

myReverse :: [a] -> [a]
myReverse xs = reverseAcc xs []

-- Verificación con QuickCheck
-- La prueba matemática en induccion_estructural.md garantiza equivalencia
-- para TODA lista. QuickCheck solo muestrea — pero es útil como sanidad.

propEquivalente :: [Int] -> Bool
propEquivalente xs = myReverse xs == reverseNaive xs

propInvolucion :: [Int] -> Bool
propInvolucion xs = myReverse (myReverse xs) == xs

propLongitud :: [Int] -> Bool
propLongitud xs = length (myReverse xs) == length xs

propPrimerElemento :: [Int] -> Bool
propPrimerElemento [] = True
propPrimerElemento xs = case myReverse xs of
    []    -> False
    (r:_) -> last xs == r

main :: IO ()
main = do
    putStrLn "=== Verificación QuickCheck ==="
    putStrLn ""
    putStrLn "Nota: QuickCheck da evidencia, la inducción da certeza."
    putStrLn "Ver induccion_estructural.md para la prueba formal completa."
    putStrLn ""

    -- Pruebas manuales con casos representativos
    let casos = [[], [1], [1,2], [1,2,3], [1..10], [1..100]]

    putStr "propEquivalente (myReverse == reverseNaive): "
    print $ all propEquivalente casos

    putStr "propInvolucion  (reverse . reverse == id):   "
    print $ all propInvolucion casos

    putStr "propLongitud    (length preservado):          "
    print $ all propLongitud casos

    putStr "propPrimerElemento (last xs == head (rev xs)):"
    print $ all propPrimerElemento (filter (not . null) casos)

    putStrLn ""
    putStrLn "Ejemplo concreto — CURP orden inverso:"
    let curp = "ROSO850312HBCNLS09"
    putStrLn $ "  Original:  " ++ curp
    putStrLn $ "  Invertida: " ++ myReverse curp
    putStrLn $ "  Vuelta:    " ++ myReverse (myReverse curp)
    putStrLn $ "  Idéntica:  " ++ show (myReverse (myReverse curp) == curp)
