;; =====================================================================
;; Programa:    higher_order.clj
;; Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
;; Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
;; Actividad:   Tema 2.2 — Funciones de orden superior
;; Fecha:       2026-07-18
;; Descripción: map/filter/reduce, composición y closures: pipeline de alumnos TecNM en Clojure
;; IA:          Generado con Claude Code, verificado y modificado por el docente
;; =====================================================================
(ns tectijuana.higher-order
  "Funciones de orden superior aplicadas a datos de alumnos TecNM.
   Conexión Nubank: el mismo patrón map/filter/reduce procesa
   millones de transacciones financieras en producción.")

;; ============================================================
;; Base de datos de alumnos — estructura inmutable
;; ============================================================

(def alumnos
  [{:nombre "García Ramírez, Carlos"    :matricula "C2150001" :promedio 8.5  :unidad "Tijuana"  :deuda 0}
   {:nombre "López Mendoza, Ana"        :matricula "C2250002" :promedio 5.8  :unidad "Mexicali" :deuda 1200}
   {:nombre "Ramos Torres, Luis"        :matricula "C2150003" :promedio 9.1  :unidad "Tijuana"  :deuda 0}
   {:nombre "Hernández Cruz, María"     :matricula "C2350004" :promedio 7.3  :unidad "Ensenada" :deuda 500}
   {:nombre "Martínez Soto, José"       :matricula "C2250005" :promedio 6.0  :unidad "Mexicali" :deuda 0}
   {:nombre "Pérez Flores, Sandra"      :matricula "C2150006" :promedio 4.5  :unidad "Tijuana"  :deuda 2000}
   {:nombre "Jiménez Ruiz, Diego"       :matricula "C2350007" :promedio 9.8  :unidad "Ensenada" :deuda 0}
   {:nombre "Morales Vega, Patricia"    :matricula "C2250008" :promedio 7.0  :unidad "Mexicali" :deuda 800}
   {:nombre "Reyes Castillo, Fernando"  :matricula "C2150009" :promedio 8.0  :unidad "Tijuana"  :deuda 0}
   {:nombre "Vargas Núñez, Claudia"     :matricula "C2350010" :promedio 5.5  :unidad "Ensenada" :deuda 400}])

;; ============================================================
;; Funciones de orden superior
;; ============================================================

(defn alumnos-aprobados
  "Retorna solo los alumnos con promedio >= 6.0.
   Usa filter — función de orden superior que recibe un predicado."
  [alumnos]
  (filter #(>= (:promedio %) 6.0) alumnos))

(defn promedios
  "Extrae solo los promedios de una colección de alumnos.
   Usa map — transforma cada elemento sin mutar la colección original."
  [alumnos]
  (map :promedio alumnos))

(defn promedio-grupo
  "Calcula el promedio del grupo completo.
   Usa reduce — colapsa la colección a un solo valor."
  [alumnos]
  (if (empty? alumnos)
    0.0
    (/ (reduce + (promedios alumnos))
       (count alumnos))))

(defn con-beca
  "Marca con beca a los alumnos con promedio >= 8.0 y sin deuda.
   Combina filter y map — composición de transformaciones."
  [alumnos]
  (->> alumnos
       (filter #(and (>= (:promedio %) 8.0)
                     (= (:deuda %) 0)))
       (map #(assoc % :beca true))))

(defn reporte-por-unidad
  "Agrupa alumnos por unidad académica.
   group-by es una función de orden superior que recibe una función llave."
  [alumnos]
  (group-by :unidad alumnos))

;; ============================================================
;; Demostración de comp y partial
;; ============================================================

(def aprobado?
  "Predicado: ¿el alumno aprobó?"
  #(>= (:promedio %) 6.0))

(def sin-deuda?
  "Predicado: ¿el alumno no tiene deuda?"
  #(= (:deuda %) 0))

(def elegible-beca?
  "Composición de predicados con comp + every-pred.
   comp encadena funciones: (comp f g) = f(g(x))"
  (every-pred aprobado? sin-deuda? #(>= (:promedio %) 8.0)))

(def normalizar-nombre
  "Transforma nombre a formato 'Apellido, Nombre' → uppercase."
  (comp clojure.string/upper-case :nombre))

;; partial — fijar algunos argumentos de una función
(def alumnos-con-promedio-minimo
  "Retorna función que filtra por promedio mínimo dado."
  (fn [minimo]
    (partial filter #(>= (:promedio %) minimo))))

(def solo-sobresalientes (alumnos-con-promedio-minimo 9.0))
(def solo-aprobados      (alumnos-con-promedio-minimo 6.0))

;; ============================================================
;; Transducers — composición eficiente sin colecciones intermedias
;; (patrón Nubank para millones de registros)
;; ============================================================

(defn pipeline-eficiente
  "Procesa alumnos con transducers — cero colecciones intermedias.
   En Nubank, este mismo patrón procesa millones de transacciones
   sin crear listas temporales en memoria."
  [alumnos]
  (let [xf (comp
             (filter aprobado?)
             (filter sin-deuda?)
             (map #(assoc % :estado :activo))
             (map :nombre))]
    (into [] xf alumnos)))

;; ============================================================
;; Programa principal — demostración completa
;; ============================================================

(defn -main []
  (println "\n=== Funciones de Orden Superior — TecNM ===\n")

  (println "--- Todos los alumnos ---")
  (doseq [a alumnos]
    (println (format "  %-35s promedio: %.1f  deuda: $%d"
                     (:nombre a) (:promedio a) (:deuda a))))

  (println "\n--- Alumnos aprobados (promedio >= 6.0) ---")
  (doseq [a (alumnos-aprobados alumnos)]
    (println "  " (:nombre a) "→" (:promedio a)))

  (println "\n--- Promedio del grupo ---")
  (println (format "  %.2f" (double (promedio-grupo alumnos))))

  (println "\n--- Con beca (promedio >= 8.0 y sin deuda) ---")
  (doseq [a (con-beca alumnos)]
    (println "  " (:nombre a) "★"))

  (println "\n--- Reporte por unidad ---")
  (doseq [[unidad grupo] (reporte-por-unidad alumnos)]
    (println (format "  %s: %d alumnos, promedio %.2f"
                     unidad
                     (count grupo)
                     (double (promedio-grupo grupo)))))

  (println "\n--- comp: nombres normalizados de sobresalientes ---")
  (doseq [a (solo-sobresalientes alumnos)]
    (println " " (normalizar-nombre a)))

  (println "\n--- Transducer pipeline (eficiente, sin listas intermedias) ---")
  (println "  Alumnos activos:" (pipeline-eficiente alumnos))

  (println "\n--- Demostración de inmutabilidad ---")
  (println "  alumnos original, primer registro:")
  (println " " (first alumnos))
  (println "  Después de 'con-beca', el original NO cambió:")
  (println " " (first alumnos)))

(-main)
