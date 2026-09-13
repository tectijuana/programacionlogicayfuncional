# Estructuras de datos persistentes e inmutables: cómo se "modifica" compartiendo memoria

**Nombre:** Duran Ponce Luis Adao Leonel.

**Matricula:** 23211951.

**Materia:** Programación Logica y funcional.

**Profesor:** Reyes Solis Rene.

## Introducción

Uno de los principios que más cuesta trabajo asimilar de la programación funcional es la inmutabilidad: una vez que una estructura de datos existe en memoria, ya no cambia durante el resto de la ejecución del programa. El problema es que en la práctica sí necesitamos representar cambios de estado todo el tiempo. 
Si cada "cambio" implicara copiar la colección completa, el costo en memoria y tiempo sería enorme. Ahí es donde entran las estructuras de datos persistentes.

Se dice que una estructura es persistente cuando, al ser "modificada", conserva también todas sus versiones anteriores. Clojure es de los lenguajes que más popularizó esta idea, logrando colecciones inmutables que además son rápidas gracias a una técnica llamada compartición de estructura.

## ¿Cómo se modifica compartiendo memoria?

La idea central es que, en lugar de copiar todo un arreglo o un árbol cada vez que se aplica un cambio, el lenguaje genera una nueva versión que reutiliza los nodos que no cambiaron de la versión anterior, y solo crea nodos nuevos en la parte donde realmente ocurrió la modificación.

    Versión Original (V1):         [A] ---> [B] ---> [C]
                                             ^
                                             |
    Nueva Versión (V2):             [D] -----+   Comparte los nodos [B] y [C]

La versión V1 sigue intacta en memoria, así que cualquier hilo que la esté leyendo en ese momento no se ve afectado. Mientras tanto, V2 es básicamente la versión "nueva": solo agrega el nodo [D] y apunta hacia los nodos [B] y [C] que ya existían, sin necesidad de duplicarlos.

## Estructura interna: árboles Trie con compresión de bits

Para que estas operaciones no se vuelvan lentas, Clojure implementa internamente árboles con un factor de ramificación de 32, es decir, cada nodo puede tener hasta 32 ramas.

Esto tiene un efecto interesante: con solo 6 niveles de profundidad, un árbol de este tipo puede almacenar hasta 32⁶, poco más de mil millones de elementos. Como consecuencia, buscar o "modificar" un elemento nunca toma más de 6 saltos entre nodos, sin importar qué tan grande sea la colección.
En la práctica eso se comporta casi como si el tiempo de acceso fuera constante.

Cuando se modifica un elemento, solo se duplican los nodos que están en el camino entre la raíz y el elemento en cuestión; todo lo demás del árbol se mantiene compartido entre las distintas versiones. A esta técnica se le conoce como copia de camino.

## Ventajas principales

Lo primero que salta a la vista es la seguridad en concurrencia: como las estructuras nunca cambian una vez creadas, varios hilos pueden leer la misma estructura al mismo tiempo sin necesidad de bloqueos ni de preocuparse por condiciones de carrera.

También resulta muy práctico para llevar un historial de versiones. Guardar estados pasados para poder deshacer una acción no representa un gasto grande de memoria, precisamente porque las versiones comparten casi todo su contenido entre sí.

Por último, la gestión de memoria queda bastante optimizada: cuando ya nadie usa una versión vieja, el recolector de basura simplemente libera los nodos que quedaron aislados, sin tocar los que siguen siendo parte de una versión activa.

## Conclusiones personales

Entender esta parte de Clojure me ayudó a ver por qué la inmutabilidad no tiene por qué ser sinónimo de lentitud. Al principio pensaba que no modificar nada significaba copiar todo cada vez, pero la compartición de estructura resuelve ese problema de una forma bastante elegante. 
Me llamó la atención sobre todo la parte de los árboles de 32 ramas, porque explica por qué en la práctica estas operaciones se sienten casi instantáneas aunque la colección sea enorme.

## Referencias

*[1] AI Future School, "Programación: Estructuras de datos persistentes e inmutables," AI Future School, s.f. [En línea]. Disponible en: https://www.aifutureschool.com/es/programacion/programacion-estructuras-de-datos-persistentes-e-inmutables.php. [Accedido: 13-sep-2026].

*[2] Academia Lab, "Estructura de datos persistente," Enciclopedia Academia Lab, s.f. [En línea]. Disponible en: https://academia-lab.com/enciclopedia/estructura-de-datos-persistente/. [Accedido: 13-sep-2026].

