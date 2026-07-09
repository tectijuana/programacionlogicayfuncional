module Main (
    Tramite(..), TipoTramite(..), Resultado(..),
    generarReporte, filtrarAprobados, resumen,
    main
) where

import Data.List (intercalate, sortBy)
import Data.Ord  (comparing)

data TipoTramite
    = AtencionMedica
    | IncapacidadTemporal
    | PensionInvalidez
    | Guarderias
    | PrestamoIMSS
    deriving (Show, Eq, Ord)

data Resultado
    = Aprobado
    | Rechazado String
    | Pendiente
    deriving (Show, Eq)

data Tramite = Tramite
    { tramiteId    :: Int
    , nss          :: String
    , nombre       :: String
    , tipo         :: TipoTramite
    , resultado    :: Resultado
    , semanas      :: Int
    } deriving (Show, Eq)

-- ── Filtros ──────────────────────────────────────────────────

filtrarAprobados :: [Tramite] -> [Tramite]
filtrarAprobados = filter (\t -> resultado t == Aprobado)

filtrarRechazados :: [Tramite] -> [Tramite]
filtrarRechazados = filter esRechazado
  where
    esRechazado t = case resultado t of
        Rechazado _ -> True
        _           -> False

-- ── Estadísticas ─────────────────────────────────────────────

resumen :: [Tramite] -> Either String String
resumen [] = Left "Sin trámites para reportar"
resumen ts =
    Right $ unlines
        [ "=== Resumen de Trámites IMSS ==="
        , "Total:      " ++ show (length ts)
        , "Aprobados:  " ++ show (length (filtrarAprobados ts))
        , "Rechazados: " ++ show (length (filtrarRechazados ts))
        , "Pendientes: " ++ show (length [t | t <- ts, resultado t == Pendiente])
        ]

-- ── Generación de reporte ────────────────────────────────────

formatearTramite :: Tramite -> String
formatearTramite t = intercalate " | "
    [ show (tramiteId t)
    , nss t
    , nombre t
    , show (tipo t)
    , formatearResultado (resultado t)
    , show (semanas t) ++ " sem"
    ]

formatearResultado :: Resultado -> String
formatearResultado Aprobado        = "APROBADO"
formatearResultado (Rechazado r)   = "RECHAZADO: " ++ r
formatearResultado Pendiente       = "PENDIENTE"

generarReporte :: [Tramite] -> String
generarReporte ts =
    let encabezado = "ID | NSS | Nombre | Trámite | Resultado | Semanas"
        separador  = replicate (length encabezado) '-'
        filas      = map formatearTramite (sortBy (comparing tramiteId) ts)
    in unlines (encabezado : separador : filas)

-- ── Main de demostración ─────────────────────────────────────

tramitesEjemplo :: [Tramite]
tramitesEjemplo =
    [ Tramite 1 "12345678901" "García López"    AtencionMedica      Aprobado         260
    , Tramite 2 "23456789012" "Pérez Ruiz"      IncapacidadTemporal Aprobado          38
    , Tramite 3 "34567890123" "Sánchez Vega"    AtencionMedica      (Rechazado "vigencia inactiva") 10
    , Tramite 4 "45678901234" "Martínez Hdz"    PensionInvalidez    (Rechazado "sin dictamen médico") 180
    , Tramite 5 "78901234567" "Rodríguez M"     PensionInvalidez    Aprobado         152
    , Tramite 6 "67890123456" "Flores Cruz"     PrestamoIMSS        Aprobado          55
    ]

main :: IO ()
main = do
    putStrLn (generarReporte tramitesEjemplo)
    case resumen tramitesEjemplo of
        Left  err -> putStrLn $ "Error: " ++ err
        Right r   -> putStr r
