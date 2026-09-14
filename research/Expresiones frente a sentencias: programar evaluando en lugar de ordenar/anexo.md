# Bitácora de uso de LLM
Inteligencia artificial utilizada: **Microsoft Copilot**

## Prompt utilizado: 
-Expresiones frente a sentencias: programar evaluando en lugar de ordenar

-Dame las fuentes bibliograficas utilizadas en esta investigación en Formato IEEE

**Resultados obtenidos:** 

En programación, una expresión se evalúa para producir un valor, mientras que una sentencia ejecuta una acción o instrucción. La diferencia clave es que las expresiones calculan y devuelven resultados, mientras que las sentencias controlan el flujo o realizan operaciones sin necesariamente devolver un valor.

| Concepto | **[Expresión](ca://s?q=Que_es_una_expresion_en_programacion)** | **[Sentencia](ca://s?q=Que_es_una_sentencia_en_programacion)** |
| --- | --- | --- |
| **Definición** | Combinación de variables, literales y operadores que se evalúa a un valor. | Unidad mínima de ejecución que realiza una acción en el programa. |
| **Resultado** | Siempre devuelve un valor (ej. ``3 ``+ ``5`` → 8). | No necesariamente devuelve un valor (ej. ``if ``x ``> ``0:``). |
| **Ejemplos** | ``3 ``+ ``5``, ``map(lambda ``x: ``x*x, ``range(10))``, ``[a.x ``for ``a ``in ``iterable]``. | ``print(42)``, ``a ``= ``7``, ``if ``x: ``do_y()``. |
| **Uso** | Se emplean para cálculos, asignaciones, condiciones en línea. | Se emplean para control de flujo, asignaciones, invocaciones de métodos. |
| **Relación** | Una expresión puede ser usada como sentencia. | No todas las sentencias son expresiones. |

🔎 Ejemplos prácticos
Expresiones en Python

python
3 + 5        # devuelve 8
"Hola".upper()  # devuelve "HOLA"
x if x > 0 else -x  # condicional en línea
Sentencias en Python

python
a = 7        # asignación
print("Hola")  # acción de salida
if x > 0:     # control de flujo
    print("positivo")

🎯 Idea clave: Evaluar vs. Ordenar
Expresiones → Evaluar  
Se centran en calcular y devolver un valor. Son como preguntas al programa: “¿Cuál es el resultado de esto?”  
Ejemplo: resultado = (x + 3) * 2.

Sentencias → Ordenar  
Son instrucciones que el programa debe ejecutar. Son como órdenes: “Haz esto ahora.”  
Ejemplo: if x > 0: print("positivo").

⚖️ Reflexión
Programar “evaluando” con expresiones fomenta un estilo más funcional y declarativo, donde el código describe qué resultado se busca. En cambio, programar con sentencias es más imperativo, indicando paso a paso qué hacer.
Por eso lenguajes como Haskell o Scala se apoyan más en expresiones, mientras que lenguajes como C++ o Java se basan en sentencias para estructurar la ejecución.

Aquí tienes las **fuentes bibliográficas en formato IEEE**, basadas **exclusivamente** en los materiales identificados mediante la búsqueda realizada. Cada referencia corresponde a un documento utilizado para fundamentar la explicación sobre **expresiones y sentencias en programación**.

---

## 📚 **Fuentes en formato IEEE**

1. **R. Pérez López**, *Expresiones*. IES Doñana, 2026.  
   Disponible en:   [pro.iesdonana.org](https://pro.iesdonana.org/apuntes/expresiones-apuntes.pdf)

2. **L. Hurtado**, “Expresiones vs Sentencias,” *M1-Apuntes*, GitHub repository.  
   Disponible en:   [Github](https://github.com/LeandroHurtado/M1-Apuntes/blob/master/09-expresiones-sentencias.md)

3. **F. Berzal**, *Expresiones y Sentencias*. Academia.edu, 2025.  
   Disponible en:   [Academia.edu](https://www.academia.edu/37281891/Expresiones_y_sentencias)

4. **DevGex**, “Expresiones vs Sentencias en Python: Un análisis detallado,” *DevGex*, Nov. 2025.  
   Disponible en:   [devgex.com](https://devgex.com/es/article/00019008)

5. **Introducción a la Programación – Expresiones y Sentencias**, documento técnico, 2025.  
   Disponible en:   [nebrija.es](https://nebrija.es/~oruano/java/2E-Expresiones.pdf)

---

Si deseas, AXEL, puedo convertir estas referencias en un **formato APA**, **MLA** o integrarlas en una **bibliografía para tu documento técnico**.

## Reflexión personal del uso de la IA

La IA si bien envía la información de una forma muy rápida y digamos "organizada" siempre es importante verificar las dichas "fuentes bibliográficas" que haya utilizado para dar la respuesta a mi prompt, la verdad es muy útil a la hora de querer indagar de forma sencilla a un tema nuevo y "especifico", ya que te mostrara información muy cerca de lo que quieres saber, y gracias a que ahí mismo indica las fuentes bibliograficas que utiliza, puedo leer por mi cuenta las paginas con calma. 



  
