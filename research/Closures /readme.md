
|Título| Proyecto de Investigación --- Programación Lógica y Funcional 2026 "B" |
|--|--|
| Author | César Lepe Garcia C22212360 |
|Fecha|1 de septiembre de 2026|




# Tema 23: Closures (Clausuras) 

## Introducción

En el contexto de la programación funcional y la teoría de lenguajes de programación, una clausura (_closure_ o clausura léxica) representa la combinación de una función y el entorno léxico dentro del cual fue declarada. Este concepto surge directamente de los desarrollos de Alonzo Church en el cálculo lambda de 1936 y fue formalizado en el contexto de la informática por Peter J. Landin en 1964 para describir el estado de evaluación en la máquina SECD.

  

Un _closure_ permite que una función interna conserve acceso a las variables de su ámbito exterior (_outer scope_), incluso después de que la función que la engloba (_outer function_) haya finalizado su ejecución y su marco de pila (_stack frame_) haya sido destruido. Esta propiedad resulta indispensable en la programación funcional, pues posibilita la creación de funciones personalizadas dinámicamente, la encapsulación de estado inmutable o privado sin recurrir a estructuras orientadas a objetos, y la implementación de técnicas avanzadas como la aplicación parcial y el _currying_.

  

## Fundamentos Teóricos y Ámbito Léxico

Para comprender el funcionamiento interno de un _closure_, es fundamental analizar cómo los lenguajes de programación gestionan los nombres y el ámbito de las variables (_scoping_).

  

### Ámbito Léxico vs. Ámbito Dinámico

Los lenguajes modernos utilizan mayoritariamente **ámbito léxico** (_lexical scoping_ o _static scoping_). Bajo este esquema, la resolución del ámbito de una variable se determina de manera rígida durante la fase de análisis del código fuente (en tiempo de compilación o interpretación), basándose exclusivamente en la posición física de las estructuras dentro del texto.

  

-   **Ámbito Léxico:** La función busca las variables en el lugar donde fue **definida**.
    
      
    
-   **Ámbito Dinámico:** La función busca las variables en el lugar desde donde fue **invocada**.
    
      
    

Los _closures_ dependen intrínsecamente del ámbito léxico. La función captura las referencias del entorno exacto donde fue redactada, garantizando predecibilidad en la resolución de identificadores.

  

### Estructura de un Closure

Desde el punto de vista de la implementación del interprete o compilador, un _closure_ no es simplemente un puntero a código ejecutable. Es una estructura de datos acoplada que contiene dos componentes esenciales:

  

1.  **El código ejecutable:** La secuencia de instrucciones de la función.
    
      
    
2.  **El objeto de entorno (Environment):** Un mapa o referencia a las variables libres que la función requiere para ejecutarse y que estaban en su contexto de creación.
    
      
    

Una **variable libre** es aquella variable que se utiliza dentro de un bloque de código pero que no fue declarada dentro de dicho bloque ni pasada como parámetro directo del mismo.

  

## Funcionamiento Interno de los Closures en Python

En Python, las funciones son objetos de primera clase (_first-class functions_). Esto implica que pueden ser asignadas a variables, pasadas como argumentos y devueltas por otras funciones.

  

Cuando una función definida en Python hace referencia a una variable libre perteneciente a una función contenedora, el intérprete evita que esa variable se destruya al terminar la ejecución de la función contenedora. Para lograr esto, Python almacena las variables capturadas en una celda de memoria especial asociada a la función interna.

  

### Captura de Variables mediante la Celda de Memoria

Podemos inspeccionar directamente la infraestructura interna que provee Python para sostener las clausuras mediante los atributos especiales de la función: `__closure__` y `__code__.co_freevars`.

  

#### Ejemplo 1: Inspección del Entorno Capturado

Python

```
def construir_multiplicador(factor):
    # La variable 'factor' pertenece al ámbito de la función contenedora.
    def multiplicar(numero):
        # 'factor' es una variable libre dentro de esta función interna.
        return numero * factor
    
    return multiplicar

# Instanciación de un closure
duplicar = construir_multiplicador(2)
triplicar = construir_multiplicador(3)

# Evaluación ejecutable
print(duplicar(10))  # Resultado: 20
print(triplicar(10)) # Resultado: 30

# Inspección técnica del objeto closure en Python
print("Variables libres capturadas:", duplicar.__code__.co_freevars)
print("Objeto celda retenido:", duplicar.__closure__)
print("Valor contenido en la celda:", duplicar.__closure__[0].cell_contents)

```

**Explicación del comportamiento:**

Cuando `construir_multiplicador(2)` finaliza, su marco en la pila de llamadas se remueve. Sin embargo, la variable `factor` no es eliminada del recolector de basura (_garbage collector_) porque la función asignada a `duplicar` guarda una referencia explícita en su tupla `__closure__`. En el momento de invocar `duplicar(10)`, Python resuelve el identificador `factor` accediendo a la celda retenida (`cell_contents`), obteniendo el valor `2`.

  

## Casos de Uso Prácticos e Industriales

### 1. Encapsulamiento de Estado y Funciones Fábrica (_Factory Functions_)

Un caso representativo del uso de clausuras es la creación de funciones especializadas mediante configuraciones iniciales, así como la emulación de estado privado sin utilizar clases explícitas (`class`).

  

#### Ejemplo 2: Acumulador de Estado Privado

Python

```
def crear_acumulador(valor_inicial=0):
    estado = valor_inicial
    
    def acumular(incremento):
        nonlocal estado  # Permite reasignar la variable libre del ámbito superior
        estado += incremento
        return estado
    
    return acumular

cuenta = crear_acumulador(100)

print(cuenta(50))   # Muestra: 150
print(cuenta(25))   # Muestra: 175
print(cuenta(10))   # Muestra: 185

```

**Detalle técnico:** La palabra reservada `nonlocal` es requerida en Python 3 cuando el _closure_ intenta reasignar (`=`) el binding de la variable libre. Sin `nonlocal`, Python consideraría que `estado` es una variable local no inicializada dentro de `acumular`, provocando un error de tipo `UnboundLocalError`.

  

### 2. Implementación de Decoradores

Los decoradores en Python son una aplicación directa de los _closures_. Un decorador es una función de orden superior que toma una función como argumento y devuelve un _closure_ que envuelve la ejecución de la función original, agregando comportamiento pre o post-ejecución sin modificar su código fuente.

  

#### Ejemplo 3: Decorador de Medición y Caché (Memoización)

Python

```
import time

def memoizar(funcion_original):
    # El diccionario 'cache' es preservado en el entorno léxico del closure
    cache = {}
    
    def funcion_envoltorio(*args):
        if args in cache:
            return cache[args]
        
        resultado = funcion_original(*args)
        cache[args] = resultado
        return resultado
    
    return funcion_envoltorio

@memoizar
def computo_pesado(n):
    time.sleep(1) # Simula un cálculo intensivo
    return n * n

# Primera ejecución: ejecuta la función y guarda en caché (tarda ~1s)
inicio = time.time()
res1 = computo_pesado(5)
print(f"Resultado 1: {res1} (Tiempo: {time.time() - inicio:.4f}s)")

# Segunda ejecución con los mismos parámetros: lee directamente del closure (tarda ~0s)
inicio = time.time()
res2 = computo_pesado(5)
print(f"Resultado 2: {res2} (Tiempo: {time.time() - inicio:.4f}s)")

```

## Trampas Frecuentes: El Problema de la Enlazadura Tardía (_Late Binding_)

Un error crítico común al implementar _closures_ ocurre cuando se generan dentro de bucles de iteración.

  

En Python, las variables en un _closure_ se enlazan por referencia y no por valor. Si las funciones se construyen dentro de un bucle que modifica la variable capturada, todas las clausuras verán el valor final alcanzado por dicha variable al terminar la iteración.

  

#### Ejemplo 4: Error de Enlazadura Tardía y su Solución

Python

```
# --- COMPORTAMIENTO INCORRECTO (Late Binding) ---
def crear_sumadores_erroneos():
    funciones = []
    for i in range(3):
        # 'i' se busca por referencia al invocar la función, no al crearla
        funciones.append(lambda x: x + i)
    return funciones

sumadores_fallidos = crear_sumadores_erroneos()

# Se esperaría: 0+0=0, 1+0=1, 2+0=2
# Resultado real: Todos suman 2 (el valor final de 'i' tras romper el bucle)
print("Comportamiento incorrecto:")
for fn in sumadores_fallidos:
    print(fn(0))  # Imprime: 2, 2, 2


# --- SOLUCIÓN 1: Fijar el parámetro mediante argumento por defecto ---
def crear_sumadores_correctos():
    funciones = []
    for i in range(3):
        # Al asignar i=i en el argumento por defecto, se evalúa en tiempo de definición
        funciones.append(lambda x, valor_capturado=i: x + valor_capturado)
    return funciones

sumadores_corregidos = crear_sumadores_correctos()

print("\nComportamiento corregido:")
for fn in sumadores_corregidos:
    print(fn(0))  # Imprime: 0, 1, 2

```

## Comparativa con la Orientación a Objetos

Existe una famosa equivalencia enunciada en la comunidad del diseño de software: _"Un closure es un objeto con un solo método; un objeto es un closure con múltiples datos."_

  

**Propiedad**

**Closure**

**Clase / Objeto**

**Enfoque de diseño**

Funcional, composable, enfocado en el comportamiento.

Imperativo / Estructural, enfocado en la entidad.

**Sintaxis**

Ligera, declarativa, basada en funciones anónimas o anidadas.

Verbosa, requiere instanciación explícita (`__init__`, `self`).

**Manejo de Estado**

Implícito mediante retención del entorno léxico.

Explícito mediante atributos del objeto (`self.variable`).

**Casos de uso ideales**

Callback handlers, decoradores, pipelines de datos, currying.

Modelado de dominio complejo con múltiples comportamientos.

## Conclusiones

Los _closures_ son una herramienta fundamental de la programación funcional que permite conectar de manera limpia el código ejecutable con las variables de su entorno sin necesidad de acudir a variables globales ni instanciar objetos complejos.

  

Su comprensión resulta crucial para dominar abstracciones de alto nivel en Python, tales como los decoradores, las expresiones lambda contextuales y los controladores de eventos en arquitecturas asíncronas. Garantizan un control refinado sobre el encapsulamiento y el ciclo de vida de los datos retenidos en memoria.
