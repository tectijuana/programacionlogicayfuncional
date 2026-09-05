# Historia y antecedentes. Miranda, Hope y los lenguajes funcionales de los años 80.

![](https://www.tijuana.tecnm.mx//wp-content/uploads/2022/03/TecNM-ITT-sgc-2018-color-scaled-e1646127126124-768x234.jpg)  

**Alumno**: Bojorquez Valdez Victor Manuel.   
**No.Control**: 23211926.  
**Carrera**: Ingeniería en Sistemas Computacionales.  
**Docente**: Rene Solis Reyes.  

### Introducción e historia de los lenguajes funcionales    
Los primeros ordenadores se construyeron en los años cuarenta. Los primerísimos modelos fueron "programados" con grandes relés. Pronto se almacenaron los programas en la memoria del ordenador, haciendo que los primeros lenguajes de programación hicieran su entrada.  

En aquel tiempo el uso de un ordenador era muy costoso y era lógico que el lenguaje de programación guardara mucha relación con la arquitectura del ordenador. Un ordenador consta de una unidad de control y una memoria. Por eso un programa consistía en instrucciones para cambiar el contenido de la memoria. La unidad de control se encargaba de ejecutarlas. De esta manera se creó el estilo de programación imperativa. Los lenguajes de programación imperativa como Pascal y C se caracterizan por la existencia de asignaciones ejecutadas consecutivamente.  

Antes de la existencia de los ordenadores se inventaron métodos para resolver problemas. Por tanto, no existía la necesidad de hablar en términos de una memoria que cambie por instrucciones en un programa. En la matemática de los últimos cuatrocientos años son muy importantes las funciones. Estas establecen la relación entre los parámetros (la "entrada") y el resultado (la "salida") de procesos definidos.  

Con cada computación, el resultado depende de una u otra forma de los parámetros. Por esa razón, una función es una buena manera de especificar una computación. Esta es la base del estilo de programación funcional. Un "programa" consiste en la definición de una o más funciones. Para la ejecución de un programa, se dan parámetros a una función y el ordenador tiene que calcular el resultado. Con este tipo de computación existe libertad en la manera de ejecución. ¿Por qué tendría que describirse en qué orden deben ejecutarse las computaciones parciales?  

Con el tiempo, al bajar los precios de los ordenadores y al subir los precios de los programadores, llega a ser más importante describir las computaciones en un lenguaje que esté más cerca del "mundo del hombre", que cerca del ordenador. Los lenguajes funcionales se unen a la tradición matemática y no están muy influidos por la arquitectura concreta del ordenador.

La base teórica de la programación imperativa fue dada (en Inglaterra) por Alan Turing en los años treinta.
También la teoría de funciones como modelo de computación proviene de los años veinte y treinta. Los
fundadores son, entre otros, M. Schönfinkel (en Alemania y Rusia), Haskell Curry (en Inglaterra) y Alonzo
Church (en los Estados Unidos).  
Fue en el comienzo de los años cincuenta cuando a alguien se le ocurrió usar esta teoría efectivamente,
como base de un lenguaje de programación. El lenguaje Lisp de John McCarthy fue el primer lenguaje de programación funcional y fue el único por muchos años.
  
### Desarrollo: Lenguajes funcionales de los años 80.
Aunque todavía se usa Lisp, no es un lenguaje que reuna las exigencias. Debido a la creciente complejidad de los programas de ordenador, se hizo necesaria una mayor verificación del programa por parte de el ordenador. Por ello el tipado adquirió una gran importancia. Por eso no es de extrañar que en los años ochenta se crearan un gran número de lenguajes funcionales tipados. Algunos ejemplos son ML, Scheme (una adaptación de Lisp), Hope y Miranda  

####       Miranda:  
![](https://upload.wikimedia.org/wikipedia/en/3/34/Miranda_logo_%28programming_language%29.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original)
  
El objetivo del sistema Miranda es proporcionar un lenguaje funcional moderno, integrado en un entorno de programación conveniente, adecuado tanto para la enseñanza como para una herramienta de programación de propósito general.  
  
Las ideas básicas de Miranda están estrechamente modeladas en las de los lenguajes anteriores SASL y KRC. Para llegar a un sistema más adecuado para abordar grandes problemas, Miranda agrega a esta base un sistema de tipo polimórfico y una estructura de biblioteca con instalaciones de tipo seguro para compilación y vinculación por separado.  
  
El lenguaje de programación Miranda es puramente funcional; no tiene efectos secundarios ni características imperativas de ningún tipo. Un programa (en realidad, no lo llamamos programa, sino "script") es un conjunto de ecuaciones que definen diversas funciones y estructuras de datos que nos interesa calcular. El orden en que se presentan las ecuaciones no suele ser relevante. Por ejemplo, no es obligatorio que la definición de una entidad preceda a su primer uso. He aquí un ejemplo muy sencillo de un script de Miranda:  
```
z = sq x / sq y  
cuadrado n = n * n  
x = a + b  
y = a - b  
a = 10  
b = 5  
```  
Nótese la ausencia de complicaciones sintácticas: Miranda es, por diseño, bastante conciso. No hay declaraciones de tipo obligatorias, aunque el lenguaje es fuertemente tipado. No hay punto y coma al final de las definiciones: el algoritmo de análisis sintáctico hace un uso inteligente del formato. Nótese que la notación para la aplicación de funciones es simplemente yuxtaposición, como en "sq x". En la definición de la función sq, "n" es un parámetro formal; su ámbito se limita a la ecuación en la que aparece (mientras que los demás nombres introducidos anteriormente tienen todo el script como ámbito).  
  
El sistema Miranda es interactivo y se ejecuta bajo UNIX como un subsistema autónomo. La acción básica es evaluar expresiones, proporcionadas por el usuario en la terminal, en el entorno establecido por el script actual. Por ejemplo, evaluar «z» en el contexto del primer script dado anteriormente produciría el resultado «9.0».  
  
El compilador de Miranda funciona en conjunto con un editor (de forma predeterminada, esto es «vi», pero se puede configurar en cualquier editor que elija el usuario). Las secuencias de comandos se vuelven a compilar automáticamente después de las ediciones, y cualquier sintaxis o error de tipo se señala de inmediato. El sistema de tipo polimórfico permite detectar una alta proporción de errores lógicos en tiempo de compilación.  

####        Hope:  
![](https://assets.dio.me/59JCwjHo0z4lPjPF-1SjMxW22H8W4ULiLgi9J8Cup3o/f:webp/q:80/L2FydGljbGVzL2NvdmVyLzM5MDQ3ZWJmLTU1YzQtNDNkNC1hNjdjLWU4ZWIyZDU2MjMwMS5qcGc)  
El objetivo fundamental del diseño y la implementación de Hope fue producir un lenguaje de programación muy simple que fomente la construcción de programas claros y manipulables. HOPE no incluye una sentencia de asignación; se considera que esto constituye una simplificación importante. El usuario puede definir libremente sus propios tipos de datos, sin necesidad de idear una codificación complicada en términos de tipos de bajo nivel.  
  
El lenguaje es fuertemente tipado e incorpora un verificador de tipos que maneja tipos polimórficos y operadores sobrecargados. Las funciones se definen mediante un conjunto de ecuaciones recursivas; el lado izquierdo de cada ecuación incluye un patrón utilizado para determinar qué ecuación aplicar a un argumento dado. La disponibilidad de tipos de orden superior arbitrarios permite definir funciones que 'empaquetan' la recursión. Se proporcionan listas de evaluación perezosa, lo que permite el uso de listas infinitas para la entrada/salida interactiva y la concurrencia. HOPE también incluye una instalación de modularización simple que se puede utilizar para proteger la implementación de un tipo de datos abstracto.  

Algunas de sus características son las siguientes:
- **Sin asignación (Transparencia referencial)**: Los lenguajes aplicativos que trabajan en términos de expresiones y sus valores, utilizando recursión en lugar de bucles, resultan mucho más claros y menos propensos a errores. Cada variable recibe un valor una sola vez donde se declara. Eliminar las asignaciones simplifica enormemente el lenguaje.
- **Uso máximo de tipos definidos por el usuario**: El usuario debe definir sus propios tipos siempre que sea posible (por ejemplo, el tipo edad en lugar del tipo entero). El lenguaje permite tipos polimórficos para que el código sea lo más general posible (por ejemplo, "lista de alphas" en lugar de una lista específica de números).
- **Operadores sobrecargados**: Es conveniente utilizar símbolos de operación comunes (como +) con una variedad de significados según el tipo de sus argumentos.  

Ejemplo de código en HOPE con un programa factorial:  
```
dec fact : num -> num;
--- fact 0 <= 1;
--- fact n <= n*fact(n-1);
```  
Cambiar el orden de las cláusulas no altera el significado del programa, ya que la coincidencia de patrones de Hope siempre da prioridad a los patrones más específicos. En Hope se requieren declaraciones explícitas de los tipos de datos ; no existe un algoritmo de inferencia de tipos .  
  
Hope proporciona dos estructuras de datos integradas : tuplas y listas 

Un lenguaje aplicativo como HOPE ofrece ventajas considerables para la verificación formal: la ausencia de sentencias de asignación y el reemplazo de la iteración por la recursión le otorga a los programas una forma simple y fácil de analizar. Además, los lenguajes aplicativos no están tan fuertemente ligados a la noción de una máquina secuencial como los lenguajes imperativos; si se dispone de una máquina paralela, las expresiones de las funciones se pueden evaluar simultáneamente.  

### Conclusiones personales.  

Según mi perspectiva, Miranda y HOPE fueron una transformación total en los lenguajes funcionales. Pasaron a ser herramientas que permitían desarrollar programas mucho más limpios que los primeros lenguajes funcionales, pudiendo ser más limpios y evitar muchos errores de tipado.  
Personalmente, no había escuchado hablar de estos lenguajes, y mucho menos había tenido la oportunidad de usarlos, pero creo que fueron una pieza importante de la computación.  

### Referencias  
- **Fokker, J. (1996)**. Programación Funcional (H. R. Ophoff & B. Sánchez J., trads.; C. Delgado Kloos & N. Martínez Madrid, revs.; 2.ª ed. rev.). Departamento de Informática, Universidad de Utrecht
- **An Overview of Miranda. (s. f.-b)**. https://www.cs.kent.ac.uk/people/staff/dat/miranda/Overview.html
- **Reclu IT. (s. f.-b)**. https://recluit.com/que-es-el-lenguaje-miranda/
- **Burstall, R. M., MacQueen, D. B., & Sannella, D. T. (1980)**. HOPE: An experimental applicative language. En Proceedings of the 1980 ACM Conference on LISP and Functional Programming (pp. 136–143). Association for Computing Machinery.
