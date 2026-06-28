# Proyecto 1 — Sistema de Validación de Trámites IMSS

## Descripción

El IMSS gestiona trámites de millones de derechohabientes: inscripción, incapacidades,
pensiones, guardería, préstamos. Cada trámite tiene requisitos de elegibilidad distintos
(semanas cotizadas, vigencia, edad, núcleo familiar). Este proyecto construye el
motor de validación en tres capas.

---

## Dominio

| Trámite | Requisitos clave |
|---------|-----------------|
| `incapacidad_temporal` | Vigencia activa + semanas_cotizadas ≥ 4 |
| `pension_invalidez` | semanas_cotizadas ≥ 150 + dictamen médico |
| `guarderías` | Hijo registrado + madre/padre trabajador vigente |
| `prestamo_imss` | semanas_cotizadas ≥ 52 + sin adeudo previo |
| `atencion_medica` | Solo vigencia activa |

---

## Arquitectura

```
capa1/validador_imss.pl     ← reglas de elegibilidad (Prolog)
capa1/restricciones.pl      ← CLP(FD): límites numéricos de semanas/edad
capa1/tests_imss.pl         ← plunit: 15+ casos de prueba

capa2/derechohabiente.erl   ← GenServer: estado de cada derechohabiente
capa2/tramite_server.erl    ← GenServer: cola de trámites pendientes
capa2/imss_sup.erl          ← Supervisor one_for_one

capa3/Reporte.hs            ← tipos algebraicos + generación de reporte
```

---

## Ejecutar

```bash
# Capa 1 — tests Prolog
swipl -g "run_tests(imss), halt" -l capa1/tests_imss.pl

# Capa 1 — interactivo
swipl -l capa1/validador_imss.pl
?- puede_tramitar(garcia_lopez, incapacidad_temporal, R).
?- falta_requisito(perez_ruiz, prestamo_imss, Falta).

# Capa 2 — compilar y arrancar Erlang
cd capa2 && erlc *.erl
erl -eval "imss_sup:start_link(), timer:sleep(2000), halt()"

# Capa 3 — compilar Haskell
cd capa3 && ghc -o reporte Reporte.hs && ./reporte
```

---

## Entregables

1. `capa1/` — validador con CLP(FD), tests todos pasando
2. `capa2/` — OTP arrancando: supervisor + al menos 2 GenServers
3. `capa3/` — Haskell compilando y generando reporte en consola
4. Este `README.md` actualizado con tus decisiones de diseño

## Crédito extra

Conectar capa 1 y capa 2: el `tramite_server` llama a SWI-Prolog vía puerto
(`open_port({spawn, "swipl ..."}, [...])`) antes de aprobar cada trámite.
