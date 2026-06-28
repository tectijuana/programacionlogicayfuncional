# Proyecto 4 — Gestor de Inventario con Reglas Fiscales SAT

## Descripción

En México, todo movimiento de inventario que supere $2,000 MXN requiere una
factura electrónica (CFDI) con RFC válido. El SAT tiene reglas de retención de
IVA, tasas diferenciadas (16%, 8%, 0%) y restricciones por tipo de producto.
Este proyecto construye el motor de validación fiscal en Prolog, el gestor de
inventario con estado en Erlang/OTP, y el módulo de facturas tipado en Haskell.

---

## Reglas fiscales implementadas

| Regla | Descripción |
|-------|-------------|
| RFC válido | 12 caracteres (persona moral) o 13 (persona física), estructura definida |
| IVA 16% | Tasa general |
| IVA 8% | Zona fronteriza (Baja California, Sonora, Chihuahua, Tamaulipas) |
| IVA 0% | Alimentos sin procesar, medicamentos |
| Exento | Libros, transporte público, servicios médicos |
| Retención | Honorarios: 10% ISR; arrendamiento: 10% IVA |

---

## Arquitectura

```
capa1/reglas_fiscales.pl    ← validación RFC, cálculo IVA, CLP(FD) para montos
capa1/productos.pl          ← base de hechos: productos y categorías fiscales
capa1/tests_sat.pl          ← plunit

capa2/inventario_server.erl ← GenServer: stock, movimientos, alertas de mínimo
capa2/factura_server.erl    ← GenServer: cola de facturas pendientes
capa2/sat_sup.erl           ← Supervisor

capa3/Factura.hs            ← tipos CFDI, validación, serialización
capa3/Factura.mli           ← (alternativa OCaml)
```

---

## Ejecutar

```bash
# Capa 1
swipl -g "run_tests(sat), halt" -l capa1/tests_sat.pl

# Capa 2
cd capa2 && erlc *.erl
erl -eval "sat_sup:start_link(), inventario_server:agregar(laptop, 15, 25000), halt()"

# Capa 3
cd capa3 && ghc -o factura Factura.hs && ./factura
```

---

## Entregables

1. `capa1/` — validador RFC + IVA con CLP(FD), tests pasando
2. `capa2/` — supervisor + inventario con movimientos registrados
3. `capa3/` — Haskell compilando con tipos CFDI correctos
4. Demostración en vivo: factura generada para una venta del inventario
