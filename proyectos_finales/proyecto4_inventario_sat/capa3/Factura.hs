module Factura (
    RFC(..), TipoPersona(..), ZonaFiscal(..),
    Producto(..), CategoriaFiscal(..),
    Factura(..), ItemFactura(..),
    crearFactura, calcularTotales, serializar,
    validarRFC, tasaIVA
) where

import Data.List (intercalate)

-- ── Tipos del dominio fiscal ──────────────────────────────────

data TipoPersona = Moral | Fisica deriving (Show, Eq)

newtype RFC = RFC String deriving (Show, Eq)

data ZonaFiscal = Fronteriza | General deriving (Show, Eq)

data CategoriaFiscal
    = TasaGeneral
    | TasaFronteriza
    | TasaCero
    | Exento
    deriving (Show, Eq)

data Producto = Producto
    { productoNombre    :: String
    , categoriaFiscal   :: CategoriaFiscal
    , precioUnitario    :: Int      -- en centavos
    } deriving (Show, Eq)

data ItemFactura = ItemFactura
    { itemProducto  :: Producto
    , cantidad      :: Int
    , subtotal      :: Int
    , iva           :: Int
    , total         :: Int
    } deriving (Show, Eq)

data Factura = Factura
    { facturaId     :: String
    , rfcEmisor     :: RFC
    , rfcReceptor   :: RFC
    , zona          :: ZonaFiscal
    , items         :: [ItemFactura]
    , totalSinIVA   :: Int
    , totalIVA      :: Int
    , totalFactura  :: Int
    } deriving (Show, Eq)

-- ── Validación ───────────────────────────────────────────────

validarRFC :: String -> Either String RFC
validarRFC rfc
    | length rfc == 12 || length rfc == 13 = Right (RFC rfc)
    | otherwise = Left ("RFC inválido: longitud " ++ show (length rfc))

-- ── Cálculo de IVA ───────────────────────────────────────────

tasaIVA :: CategoriaFiscal -> ZonaFiscal -> Int
tasaIVA Exento      _           = 0
tasaIVA TasaCero    _           = 0
tasaIVA TasaGeneral Fronteriza  = 8
tasaIVA TasaGeneral General     = 16
tasaIVA TasaFronteriza _        = 8

calcularItem :: ZonaFiscal -> Producto -> Int -> ItemFactura
calcularItem zona prod cant =
    let sub  = precioUnitario prod * cant
        tasa = tasaIVA (categoriaFiscal prod) zona
        iv   = (sub * tasa) `div` 100
        tot  = sub + iv
    in ItemFactura prod cant sub iv tot

-- ── Construcción de factura ───────────────────────────────────

crearFactura :: String -> String -> String -> ZonaFiscal
             -> [(Producto, Int)]
             -> Either String Factura
crearFactura fid rfcE rfcR zona' lineas = do
    emisor   <- validarRFC rfcE
    receptor <- validarRFC rfcR
    let itms      = map (uncurry (calcularItem zona')) lineas
        sinIVA    = sum (map subtotal itms)
        ivaTotal  = sum (map iva itms)
        totalFact = sinIVA + ivaTotal
    Right $ Factura fid emisor receptor zona' itms sinIVA ivaTotal totalFact

calcularTotales :: Factura -> (Int, Int, Int)
calcularTotales f = (totalSinIVA f, totalIVA f, totalFactura f)

-- ── Serialización (texto) ─────────────────────────────────────

formatCentavos :: Int -> String
formatCentavos c =
    let (pesos, centavos) = c `divMod` 100
    in "$" ++ show pesos ++ "." ++ (if centavos < 10 then "0" else "") ++ show centavos

serializar :: Factura -> String
serializar f = unlines
    [ "╔══════════════════════════════════════╗"
    , "║        CFDI — Factura Electrónica    ║"
    , "╚══════════════════════════════════════╝"
    , "Folio:    " ++ facturaId f
    , "Emisor:   " ++ rfc (rfcEmisor f)
    , "Receptor: " ++ rfc (rfcReceptor f)
    , "Zona:     " ++ show (zona f)
    , ""
    , "─── Conceptos ───────────────────────"
    , intercalate "\n" (map formatItem (items f))
    , ""
    , "─── Totales ─────────────────────────"
    , "  Subtotal:  " ++ formatCentavos (totalSinIVA f)
    , "  IVA:       " ++ formatCentavos (totalIVA f)
    , "  TOTAL:     " ++ formatCentavos (totalFactura f)
    ]
  where
    rfc (RFC r) = r
    formatItem i = "  " ++ productoNombre (itemProducto i)
                       ++ " x" ++ show (cantidad i)
                       ++ "  " ++ formatCentavos (total i)

-- ── Main de demostración ─────────────────────────────────────

laptop :: Producto
laptop = Producto "Laptop Dell XPS" TasaGeneral 250000   -- $2,500.00 MXN

silla :: Producto
silla = Producto "Silla Ergonómica" TasaGeneral 350000   -- $3,500.00 MXN

insulina :: Producto
insulina = Producto "Insulina NPH" TasaCero 45000        -- $450.00 MXN

main :: IO ()
main =
    case crearFactura "A-2026-001" "XAXX010101000" "GALO900101AB1" General
             [(laptop, 2), (silla, 1), (insulina, 3)] of
        Left  err -> putStrLn $ "Error: " ++ err
        Right fac -> putStr (serializar fac)
