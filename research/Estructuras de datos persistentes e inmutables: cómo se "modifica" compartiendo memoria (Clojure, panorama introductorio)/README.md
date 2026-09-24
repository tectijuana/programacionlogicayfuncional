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

Para que estas operaciones no se vuelvan lentas, Clojure implementa internamente árboles con un factor de ramificación de 32, es decir, cada nodo puede tener hasta 32 ramas. En los **vectores** el índice se divide en grupos de 5 bits (2⁵ = 32) y cada grupo elige la rama en un nivel del árbol (*bit-partitioned vector trie*); en los **mapas y conjuntos** se usa la misma idea sobre el *hash* de la llave (*Hash Array Mapped Trie*, HAMT, propuesto por Phil Bagwell [3]).

Esto tiene un efecto interesante: con solo 6 niveles de profundidad, un árbol de este tipo puede almacenar hasta 32⁶, poco más de mil millones de elementos. Como consecuencia, buscar o "modificar" un elemento en una colección de ese tamaño toma a lo más 6 saltos entre nodos.
Formalmente el costo es O(log₃₂ n): no es constante, pero crece tan despacio que en la práctica se comporta casi como si lo fuera.

Cuando se modifica un elemento, solo se duplican los nodos que están en el camino entre la raíz y el elemento en cuestión; todo lo demás del árbol se mantiene compartido entre las distintas versiones. A esta técnica se le conoce como copia de camino.

## Verificación en Clojure (REPL)

> *Sección agregada durante la revisión docente para respaldar con código ejecutable las afirmaciones anteriores. Probado con Clojure 1.12 (`clojure -M archivo.clj`).*

```clojure
;; 1. "Modificar" un vector devuelve una versión nueva; la original no cambia
(def v1 [:a :b :c])
(def v2 (assoc v1 0 :d))
(println "v1 =" v1 " v2 =" v2)            ; v1 = [:a :b :c]  v2 = [:d :b :c]

;; 2. Compartición de estructura en listas: la cola es el MISMO objeto
(def l1 '(:b :c))
(def l2 (cons :a l1))
(println "comparte cola?" (identical? l1 (rest l2)))   ; true

;; 3. Copia de camino en un vector grande: solo cambia la ruta raíz→hoja
(def grande (vec (range 1000000)))
(def grande2 (assoc grande 999999 :x))
(println "original intacto:" (peek grande) " nueva versión:" (peek grande2))
;; original intacto: 999999  nueva versión: :x

;; 4. Historial de versiones barato (deshacer)
(def historial (reductions conj [] [1 2 3]))
(println "versiones:" historial)           ; ([] [1] [1 2] [1 2 3])
```

El ejemplo 2 es exactamente el diagrama V1/V2 de arriba: `identical?` compara referencias, no contenido, y devuelve `true` porque `l2` no copió `(:b :c)`, apunta a la misma lista. El ejemplo 3 "modifica" un vector de un millón de elementos creando solo los ~4 nodos del camino (log₃₂ 1 000 000 ≈ 4), no un millón de copias.

### ¿Y si sí necesito estado que cambie?

La inmutabilidad no elimina el estado: lo **aísla** en referencias explícitas que apuntan a valores inmutables. Clojure ofrece `atom` para un solo valor y `ref` + `dosync` (memoria transaccional por software, STM) cuando varios valores deben cambiar de forma coordinada:

```clojure
;; atom: un solo valor, actualización atómica
(def contador (atom {:visitas 0}))
(swap! contador update :visitas inc)
(println "atom:" @contador)                ; atom: {:visitas 1}

;; ref + dosync: dos cuentas que deben cambiar juntas o no cambiar
(def cuenta-a (ref 1000))
(def cuenta-b (ref 0))
(dosync
  (alter cuenta-a - 250)
  (alter cuenta-b + 250))
(println "ref: A =" @cuenta-a " B =" @cuenta-b " total =" (+ @cuenta-a @cuenta-b))
;; ref: A = 750  B = 250  total = 1000
```

Si otra transacción modifica `cuenta-a` al mismo tiempo, `dosync` reintenta la transacción completa; ningún hilo puede observar un estado intermedio en el que el dinero "desapareció". Esto funciona porque cada versión de las cuentas es un valor persistente: reintentar es barato y las versiones anteriores siguen siendo válidas para quien las esté leyendo.

**Caso real:** Nubank, el banco digital más grande de Latinoamérica, construyó su plataforma en Clojure sobre Datomic, una base de datos que lleva la misma idea a disco: los hechos nunca se sobrescriben, se acumulan, y cualquier versión anterior de la base puede consultarse [5]. El ejemplo de las cuentas modela el tipo de problema (transferencias que deben ser consistentes) que motiva ese diseño.

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

*[3] P. Bagwell, "Ideal Hash Trees," École Polytechnique Fédérale de Lausanne (EPFL), Tech. Rep. LAMP-REPORT-2001-001, 2001.

*[4] R. Hickey, "Data Structures," Clojure Reference. [En línea]. Disponible en: https://clojure.org/reference/data_structures. [Accedido: 24-sep-2026].

*[5] Nubank, "Clojure" (artículos etiquetados), Building Nubank — blog de ingeniería. [En línea]. Disponible en: https://building.nubank.com/tag/clojure/. [Accedido: 24-sep-2026].
