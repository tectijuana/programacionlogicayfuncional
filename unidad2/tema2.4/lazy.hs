-- =====================================================================
-- Programa:    lazy.hs
-- Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
-- Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
-- Actividad:   Tema 2.4 — Evaluación perezosa
-- Fecha:       2026-07-18
-- Descripción: Listas infinitas (Fibonacci, primos) con evaluación perezosa en Haskell
-- IA:          Generado con Claude Code, verificado y modificado por el docente
-- =====================================================================
-- Archivo: lazy.hs
-- Tema 2.4: Evaluación Perezosa en Haskell
--
-- Compilar: ghc -o lazy lazy.hs && ./lazy
-- REPL:     ghci lazy.hs
--
-- Haskell es lazy por defecto: ninguna expresión se evalúa
-- hasta que su resultado es estrictamente necesario.

module Main where

import Data.List (nub)
import Numeric   (showFFloat)
import System.IO (hFlush, stdout)

-- ============================================================
-- 1. LISTA INFINITA DE FIBONACCI
--    Esta definición es circular — funciona gracias a laziness.
--    fibs se define en términos de sí misma, pero Haskell
--    solo evalúa los elementos que se solicitan.
-- ============================================================

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- ============================================================
-- 2. CRIBA DE ERATÓSTENES — lista infinita de primos
--    Nunca termina de generarse; solo calculamos lo que pedimos.
-- ============================================================

primes :: [Integer]
primes = criba [2..]
  where
    -- Filtra múltiplos de p del resto de la lista
    criba (p:xs) = p : criba [x | x <- xs, x `mod` p /= 0]
    criba []     = []  -- rama inalcanzable, pero hace el pattern exhaustivo

-- ============================================================
-- 3. GENERADORES LAZY PERSONALIZADOS
-- ============================================================

-- Potencias de 2: 1, 2, 4, 8, 16, ...
potenciasDe2 :: [Integer]
potenciasDe2 = iterate (*2) 1

-- Números triangulares: 1, 3, 6, 10, 15, ...
triangulares :: [Integer]
triangulares = scanl1 (+) [1..]

-- ============================================================
-- 4. COMPARACIÓN MEMORIA: LAZY VS. EAGER
--    En Haskell todo es lazy, pero podemos forzar evaluación
--    con 'seq' para medir la diferencia conceptual.
-- ============================================================

-- Suma lazy: GHC puede optimizar esto sin crear la lista completa
sumaLazyN :: Integer -> Integer
sumaLazyN n = sum (take (fromIntegral n) [1..])

-- Versión con fórmula directa — para comparar resultado
sumaFormula :: Integer -> Integer
sumaFormula n = n * (n + 1) `div` 2

-- ============================================================
-- MAIN: demostraciones
-- ============================================================

main :: IO ()
main = do
    putStrLn "=============================================="
    putStrLn " Tema 2.4 — Evaluación Perezosa en Haskell"
    putStrLn "=============================================="
    putStrLn ""

    -- Demo 1: Fibonacci
    putStrLn "--- 1. Primeros 20 números de Fibonacci ---"
    print (take 20 fibs)
    putStrLn ""

    -- Demo 2: Fibonacci grande — sin overflow (Integer es precisión arbitraria)
    putStrLn "--- Fibonacci en la posición 100 ---"
    print (fibs !! 100)
    putStrLn ""

    -- Demo 3: Primos
    putStrLn "--- 2. Primeros 50 números primos ---"
    print (take 50 primes)
    putStrLn ""

    -- Demo 4: Primos entre 900 y 1000
    putStrLn "--- Primos entre 900 y 1000 ---"
    print (takeWhile (<= 1000) (dropWhile (< 900) primes))
    putStrLn ""

    -- Demo 5: Potencias de 2
    putStrLn "--- 3. Primeras 15 potencias de 2 ---"
    print (take 15 potenciasDe2)
    putStrLn ""

    -- Demo 6: Lista infinita con takeWhile
    putStrLn "--- Números triangulares menores a 100 ---"
    print (takeWhile (< 100) triangulares)
    putStrLn ""

    -- Demo 7: Composición lazy — no crea listas intermedias completas
    putStrLn "--- 4. Composición lazy: primeros 10 primos que son Fibonacci ---"
    let primosFib = take 10 [x | x <- primes, x `elem` take 200 fibs]
    print primosFib
    putStrLn ""

    -- Demo 8: Suma de millón de números — lazy no construye la lista en RAM
    putStrLn "--- 5. Suma 1..1,000,000 (lazy, sin construir la lista completa) ---"
    let n = 1000000 :: Integer
    let sumL = sumaLazyN n
    let sumF = sumaFormula n
    putStrLn $ "  sum (take 1000000 [1..]) = " ++ show sumL
    putStrLn $ "  fórmula n*(n+1)/2        = " ++ show sumF
    putStrLn $ "  ¿Iguales? " ++ show (sumL == sumF)
    putStrLn ""

    -- Demo 9: zip de dos listas infinitas
    putStrLn "--- 6. zip fibs primes — primeros 10 pares ---"
    print (take 10 (zip fibs primes))
    putStrLn ""

    putStrLn "=============================================="
    putStrLn " Clave: 'take N listaInfinita' es O(N)"
    putStrLn " Los elementos más allá de N NUNCA se calculan."
    putStrLn "=============================================="
