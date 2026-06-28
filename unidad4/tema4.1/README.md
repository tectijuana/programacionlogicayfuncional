# Tema 4.1 — Desarrollo de Programas Lógicos con Módulos

## Objetivo

Aplicar metodología formal de desarrollo en Prolog: especificación de modos,
documentación de determinismo e invariantes, y encapsulamiento con módulos.

## Caso de estudio: Validador de CURP mexicana

La CURP (Clave Única de Registro de Población) tiene 18 caracteres con estructura definida:

```
SAAA AAMMDD H/M EE CCC NN
│    │      │   │  │   └─ 2: dígito verificador + homoclave
│    │      │   │  └───── 3: consonantes internas de apellidos
│    │      │   └──────── 2: clave de estado (BC, SO, DF...)
│    │      └──────────── 1: sexo (H=hombre, M=mujer)
│    └─────────────────── 6: fecha AAMMDD
└──────────────────────── 4: iniciales (apellido1 + apellido2 + nombre)
```

## Instrucciones

```bash
# Cargar y ejecutar tests
swipl -g "run_tests, halt" -l modulos_prolog.pl

# Modo interactivo
swipl -l modulos_prolog.pl
?- validar_curp('GASA850101HBCRRN09', R).
?- extraer_componentes('GASA850101HBCRRN09', C).
?- fecha_nacimiento('GASA850101HBCRRN09', F).
```

## Metodología de desarrollo en Prolog

### 1. Especificación antes de código

Para cada predicado, documentar ANTES de implementar:
- **Aridad**: `predicado/N`
- **Modo**: `+` entrada, `-` salida, `?` cualquiera
- **Determinismo**: `det` (siempre 1 solución), `semidet` (0 o 1), `nondet` (0 o más)
- **Invariante**: qué debe ser verdad para que el predicado tenga sentido

### 2. Invariantes de predicados

```prolog
%% validar_curp/2 — semidet
%% Invariante: CURP debe ser átomo de exactamente 18 caracteres
%% Falla silenciosamente si no cumple — no lanza excepciones
```

### 3. Módulos para encapsulamiento

```prolog
:- module(nombre_modulo, [predicado_publico/aridad, ...]).
%% Solo los predicados en la lista son accesibles desde fuera
%% Los auxiliares quedan privados al módulo
```

## Preguntas de reflexión

1. ¿Por qué documentar determinismo es importante para quien usa el predicado?
2. ¿Qué diferencia hay entre un predicado `semidet` y uno `nondet`?
3. ¿Por qué en Prolog preferimos fallar silenciosamente sobre lanzar excepciones?
4. ¿Cómo cambiaría la interfaz si quisiéramos `validar_curp/2` sea `nondet` (genere CURPs válidas)?
5. Compara la separación módulo/implementación en Prolog con `.mli`/`.ml` en OCaml.

## Entregable

- `modulos_prolog.pl` con todos los predicados documentados y tests pasando
- Screenshot de `?- run_tests.` mostrando todos en verde
