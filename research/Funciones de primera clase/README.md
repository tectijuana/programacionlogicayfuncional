# Funciones de primera clase: pasar y devolver funciones como cualquier dato.
<p align="center">
<img width="1200" height="675" alt="image" src="https://github.com/user-attachments/assets/46fa5800-6fee-43d4-937e-8af2438956ad" /></p></div>

--- 
### Autor: Gomez Cuevas Carlos.
### Grupo: 4:00 p.m.
### Materia: Programacion Logica y Funcional.
### Profesor: Rene Solis Reyes.
---
## Introduccion.
Se dice que un lenguaje de programación tiene funciones de primera clase si trata las funciones como ciudadanos de primera clase. Esto significa que admite:
* Poder pasar funciones como argumentos a otras funciones.
* Que el valor de retorno de una función sea otra función.
* Asignar funciones a variables o almacenarlas en estructuras de datos.

---

## Concepto.
Una función de primera clase es una función que se trata como una "cosa en sí misma", capaz de mantenerse sola y de ser tratada independientemente.
Otra forma de describir las funciones de primera clase es la de funciones como datos. Es decir, una función de primera clase puede ser asignada a una variable como cualquier otro dato. El término fue acuñado por Christopher Strachey en el contexto de "funciones como ciudadanos de primera clase" a mediados de los años 60.

---
## Propiedades.
Para que una función cumpla con esta definicion, debe permitir que una funcion pueda:
* Asignarse a una variable o constante: Guardar una función en una variable como si fuera un dato cualquiera.
* Pasarse como argumento a otra función: Enviar una función para que otra la ejecute (la base de los callbacks).
* Retornarse desde otra función: Crear fábricas de funciones o closures (clausuras).
* Almacenarse en estructuras de datos: Guardar funciones dentro de arreglos, listas, diccionarios u objetos.

## Diferencias ante las funciones de orden superior.
| Característica | Funciones de primera clase | Funciones de orden superior |
| :--- | :--- | :--- |
| **Definición** | Funciones que pueden tratarse como cualquier otro valor (asignadas a variables, pasadas como argumentos, devueltas por otras funciones). | Funciones que toman otras funciones como argumentos o devuelven funciones. |
| **Función como valor** | Sí, las funciones son ciudadanos de primera clase (pueden ser asignadas, aprobadas o devueltas). | Sí, las funciones pueden ser transmitidas o devueltas por otras funciones. |
| **Pasando funciones como argumentos** | Las funciones pueden pasarse como argumentos a otras funciones. | Una función de orden superior requiere específicamente funciones como argumentos. |
| **Funciones de regreso** | Las funciones pueden devolver otras funciones, pero esto por sí solo no las convierte en orden superior. | Las funciones de orden superior deben devolver otra función. |
| **Caso de uso** | Cualquier función que pueda tratarse como un objeto de primera clase, incluyendo asignación y paso a otras funciones. | Se usa cuando quieres pasar comportamiento como argumento o devolver comportamiento (como callbacks, gestores de eventos, etc.). |

---
## Ejemplos.
```javascript
function add(a, b){
return a + b;
}
let sum = add;

function average(a, b, fn) {
return fn(a, b) / 2;
}

let result = average(10, 20, sum);

console.log(result);
```
En este ejemplo lo que tenemos es a la función "add", la cual la usamos para sumar los números "a" y "b", esta función se puede usar de dos formas, ya sea llamándola directamente "add" o alternativamente llamando la variable "sum".
### ¿Como paso una funcion a otra?
En este mismo ejemplo se declara la función "average" aquí se usan tres argumentos siendo "fn" una función. 
Entonces se puede pasar la funcion "sum" a la funcion "average" dando el resultado de la suma.
```javascript
let result = average(10, 20, sum);
```

### Devolver funciones desde funciones.
```javascript
// Función que devuelve otra función
function crearMultiplicador(factor) {
    return function(numero) {
        return numero * factor;
    };
}

// Creamos funciones especializadas a partir de la primera
const duplicar = crearMultiplicador(2);
const triplicar = crearMultiplicador(3);

// Invocamos las funciones generadas
console.log(duplicar(5));  // 10
console.log(triplicar(5)); // 15
```
En este caso se crea la función "crearMultiplicador" la cual recibe un parámetro "factor" retornando asi otra nueva funcion.
La función retornada "recuerda" el valor del argumento con el que fue creada (factor = 2 o factor = 3), incluso después de que crearMultiplicador terminó de ejecutarse. Al almacenar el resultado en las constantes "duplicar" o "triplicar", obtienes rutinas independientes y configurables listas para usarse.

## Bibliografia
* M. Rolfo, “¿Qué es la programación funcional? Una guía práctica,” Codigoencasa.com, Oct. 24, 2022. https://codigoencasa.com/programacion-funcional/
* Wikipedia contributors, “First-class function,” Wikipedia, Jul. 07, 2026. https://en.wikipedia.org/wiki/First-class_function
* GeeksforGeeks, “Difference between FirstClass and HigherOrder Functions in JavaScript,” GeeksforGeeks, Jul. 23, 2025. https://www.geeksforgeeks.org/javascript/difference-between-first-class-and-higher-order-functions-in-javascript/
* Estrada Web Group, “Qué es una función de primera clase en JavaScript,” Estrada Web Group, Dec. 15, 2022. https://estradawebgroup.com/Post/Que-es-una-funcion-de-primera-clase-en-JavaScript/20586
