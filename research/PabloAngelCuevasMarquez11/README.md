# Tema 11: Funciones Puras — Definición, Ejemplos y Contraejemplos

**Materia:** Programación Lógica y Funcional  
**Bloque:** Funcional Introductorio
**Tema:** 11. Funciones puras: definición, ejemplos y contraejemplos 
**Nombre del estudiante:** Pablo Angel Cuevas Marquez 
**Fecha:** 06/09/2026

---

## Índice
1. Definición de Función Pura
2. Propiedades Fundamentales
3. Ejemplos de Funciones Puras
4. Contraejemplos (Funciones Impuras)
5. Tabla Comparativa
6. Importancia en la Programación Funcional
7. Conclusión

---

## 1. Definición de Función Pura

En el paradigma de la **programación funcional**, una **función pura** es un bloque de código autocontenido que cumple estrictamente con dos reglas indispensables:

1. **Determinismo (Misma entrada → Misma salida):** Para un conjunto dado de argumentos de entrada, la función *siempre* devolverá exactamente el mismo valor de salida, sin importar cuántas veces sea ejecutada, el momento o las condiciones del entorno.
2. **Ausencia de efectos secundarios (*Side Effects*):** La evaluación de la función no altera ni depende de ningún estado o dato fuera de su propio ámbito local. No modifica variables globales, no muta sus argumentos de entrada, no realiza operaciones de I/O (lectura/escritura en disco, consola, red) ni altera el estado del sistema.

Representación matemática:

$$f(x) = y$$

Si se evalúa $f(2)$ y el resultado es $4$, $f(2)$ siempre evaluará a $4$, sin "cambiar el mundo" alrededor de ella.

---

## 2. Propiedades Fundamentales

Las funciones puras otorgan ventajas arquitectónicas clave al software:

* **Transparencia Referencial:** Significa que una llamada a una función pura se puede reemplazar directamente por su valor de retorno sin cambiar el comportamiento del programa. Por ejemplo, si `sumar(2, 3)` retorna `5`, podemos sustituir `sumar(2, 3)` por `5` en cualquier parte del código.
* **Memorización y Caching:** Debido a que el resultado depende únicamente de las entradas, el entorno de ejecución puede guardar en caché el resultado de cálculos computacionalmente costosos.
* **Fácil Comprobación (Testabilidad):** No requiere simular (*mocking*) bases de datos, APIs externas o estados globales para escribir pruebas unitarias.
* **Seguridad en Concurrencia y Paralelismo:** Al no modificar memoria compartida, múltiples hilos o procesos pueden ejecutar la misma función pura simultáneamente sin causar *race conditions* (condiciones de carrera).

---

## 3. Ejemplos de Funciones Puras

### Ejemplo A: Operaciones Matemáticas (JavaScript)

```javascript
// Pura: El resultado depende únicamente de los parámetros 'a' y 'b'
function sumar(a, b) {
  return a + b;
}

console.log(sumar(5, 10)); // Siempre retorna 15
```

### Ejemplo B: Definición de Tipos y Funciones (Haskell)

```haskell
-- Pura: Transforma un entero devolviendo su doble sin alterar nada externo
duplicar :: Int -> Int
duplicar x = x * 2
```

### Ejemplo C: Transformación Inmutable de Datos (Python)

```python
# Pura: Devuelve una nueva lista con los elementos elevados al cuadrado.
# La lista original 'numeros' permanece intacta.
def elevar_al_cuadrado(numeros):
    return [x ** 2 for x in numeros]

original = [1, 2, 3, 4]
resultado = elevar_al_cuadrado(original)
# original sigue siendo [1, 2, 3, 4]
```

---

## 4. Contraejemplos (Funciones Impuras)

Una función se vuelve impura cuando rompe el determinismo o genera efectos secundarios.

### Contraejemplo 1: Dependencia de Estado Externo Mutador

```javascript
let tasaIVA = 0.16;

// IMPURA: Depende de una variable global que puede cambiar con el tiempo
function calcularPrecioTotal(precioBase) {
  return precioBase + (precioBase * tasaIVA);
}
```

**¿Por qué es impura?** Si en otro punto del programa `tasaIVA` cambia a `0.18`, `calcularPrecioTotal(100)` devolverá un valor diferente a pesar de recibir el mismo argumento (100).

### Contraejemplo 2: Mutación de Parámetros (Efecto Secundario)

```javascript
// IMPURA: Modifica el arreglo original que se le pasa por referencia
function agregarElementoImpuro(lista, nuevoItem) {
  lista.push(nuevoItem); // Mutación de la entrada
  return lista;
}
```

**Refactorización a Función Pura:**

```javascript
// PURA: Crea y retorna un nuevo arreglo utilizando el operador spread
function agregarElementoPuro(lista, nuevoItem) {
  return [...lista, nuevoItem];
}
```

### Contraejemplo 3: No-determinismo (Azar o Tiempo del Sistema)

```python
import random
from datetime import datetime

# IMPURA: Utiliza aleatoriedad
def generar_codigo_usuario(nombre):
    return f"{nombre}_{random.randint(1000, 9999)}"

# IMPURA: Depende del reloj del sistema
def obtener_fecha_actual():
    return datetime.now()
```

**¿Por qué son impuras?** Múltiples ejecuciones con la misma entrada producen resultados completamente diferentes.

### Contraejemplo 4: Entrada y Salida (I/O, Consola, Red, Base de Datos)

```javascript
// IMPURA: Modifica la consola del sistema y realiza peticiones HTTP
function guardarUsuario(usuario) {
  console.log("Enviando usuario al servidor...");
  fetch("/api/usuarios", {
    method: "POST",
    body: JSON.stringify(usuario)
  });
}
```

**¿Por qué es impura?** Interactúa directamente con el mundo exterior (la consola y la red), alterando el estado externo.

---

## 5. Tabla Comparativa

| Criterio | Función Pura | Función Impura |
|---|---|---|
| **Determinismo** | Sí: Misma entrada → Misma salida | No: El resultado puede variar |
| **Efectos Secundarios** | Ninguno | Sí: Modifica variables, archivos, BD, etc. |
| **Dependencia de Datos** | Exclusivamente de sus argumentos | Argumentos + Variables globales / Entorno |
| **Transparencia Referencial** | Sí | No |
| **Facilidad de Pruebas** | Muy alta (No requiere Mocks) | Media/Baja (Requiere configuración de entorno) |
| **Concurrencia** | Totalmente segura | Riesgo de inconsistencias |

---

## 6. Importancia en la Programación Funcional

En los programas reales, los efectos secundarios son necesarios (escribir en una base de datos, mostrar datos en pantalla, procesar peticiones web).

El objetivo de la programación funcional no es eliminar por completo las funciones impuras, sino **aislarlas**. El patrón recomendado es construir el núcleo de la aplicación (*Core*) utilizando únicamente funciones puras, dejando la interacción con el mundo exterior en los bordes (*Shell* o límites del sistema).

---

## 7. Conclusión

Las funciones puras son la parte fundamental para la construcción del paradigma funcional. Al garantizar determinismo y eliminar los efectos secundarios que no ayuden en nada, reducen drásticamente el peso y la carga requerida para rastrear el estado de un programa. Poder adoptar funciones puras permite que se puedan crear software más fácil para razonar, probar, mantener y paralelizar.
