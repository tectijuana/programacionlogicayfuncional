;; =====================================================================
;; Programa:    horario_server.clj
;; Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
;; Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
;; Actividad:   Proyecto Final P2 — Turnos maquiladora, capa 2
;; Fecha:       2026-07-18
;; Descripción: Estado del turno con atom e historial inmutable en Clojure
;; IA:          Generado con Claude Code, verificado y modificado por el docente
;; =====================================================================
(ns maquiladora-server
  "Gestión de turnos de planta maquiladora con estado inmutable en Clojure.
   Usa atom para el turno actual y registro append-only de cambios.")

;; ── Estado central ────────────────────────────────────────────
;; El turno es un mapa: {[puesto estacion] -> {:inicio H :fin H}}

(def turno-actual
  "Atom que guarda las asignaciones del turno vigente."
  (atom {}))

(def historial-cambios
  "Registro append-only de todas las modificaciones al turno."
  (atom []))

;; ── Catálogo de puestos ───────────────────────────────────────

(def horas-puesto
  {:ensamble-pcb       5
   :soldadura          5
   :inspeccion-calidad 4
   :empaque            4
   :logistica          5
   :capacitacion       2
   :mantenimiento      4
   :control-inventario 3})

(def estaciones-especializadas #{:est-pcb :est-soldadura})

(defn requiere-especializada? [puesto]
  (contains? #{:ensamble-pcb :soldadura} puesto))

;; ── Funciones puras ───────────────────────────────────────────

(defn- traslape?
  "Verdad si los bloques [i1 f1] y [i2 f2] se solapan."
  [i1 f1 i2 f2]
  (and (<= i1 f2) (<= i2 f1)))

(defn conflicto?
  "Verdad si agregar esta asignación crea conflicto de estación/bloque."
  [turno puesto estacion inicio fin]
  (some (fn [[[p e] {:keys [inicio-bloque fin-bloque]}]]
          (and (= e estacion)
               (not= p puesto)
               (traslape? inicio fin inicio-bloque fin-bloque)))
        turno))

(defn estacion-valida?
  "Verdad si la estación es compatible con el puesto."
  [puesto estacion]
  (if (requiere-especializada? puesto)
    (contains? estaciones-especializadas estacion)
    (not (contains? estaciones-especializadas estacion))))

;; ── Operaciones con estado ────────────────────────────────────

(defn asignar!
  "Asigna un puesto a una estación a partir del bloque de inicio.
   Retorna :ok o {:error razon}."
  [puesto estacion inicio]
  (let [horas (horas-puesto puesto)
        fin   (+ inicio horas -1)]
    (cond
      (nil? horas)
      {:error :puesto-desconocido}

      (not (estacion-valida? puesto estacion))
      {:error :estacion-incompatible}

      (or (< inicio 0) (> fin 15))
      {:error :bloque-fuera-de-turno}

      (or (= inicio 7) (= fin 7) (and (< inicio 7) (> fin 7)))
      {:error :cruza-descanso}

      (conflicto? @turno-actual puesto estacion inicio fin)
      {:error :conflicto-de-estacion}

      :else
      (do
        (swap! turno-actual assoc [puesto estacion]
               {:inicio-bloque inicio :fin-bloque fin})
        (swap! historial-cambios conj
               {:accion :asignar :puesto puesto :estacion estacion
                :inicio inicio :fin fin
                :timestamp (System/currentTimeMillis)})
        :ok))))

(defn turno-tabla
  "Retorna el turno actual ordenado por hora de inicio."
  []
  (->> @turno-actual
       (map (fn [[[puesto estacion] {:keys [inicio-bloque fin-bloque]}]]
              {:puesto   puesto
               :estacion estacion
               :inicio   (+ 6 inicio-bloque)
               :fin      (+ 6 fin-bloque 1)}))
       (sort-by :inicio)))

;; ── Demo ──────────────────────────────────────────────────────

(defn -main []
  (println "=== Turno Matutino — Planta Maquiladora Tijuana ===")
  (asignar! :ensamble-pcb       :est-pcb       0)   ;; 6:00–11:00
  (asignar! :soldadura          :est-soldadura  0)   ;; 6:00–11:00
  (asignar! :inspeccion-calidad :est-01         0)   ;; 6:00–10:00
  (asignar! :empaque            :est-02         0)   ;; 6:00–10:00
  (asignar! :logistica          :est-03         8)   ;; 14:00–19:00
  (asignar! :capacitacion       :est-04         8)   ;; 14:00–16:00
  (asignar! :mantenimiento      :est-01         8)   ;; 14:00–18:00
  (asignar! :control-inventario :est-02        12)   ;; 18:00–21:00
  (println "\nAsignaciones del turno:")
  (doseq [{:keys [puesto estacion inicio fin]} (turno-tabla)]
    (printf "  %-22s %-14s %d:00 – %d:00%n"
            (name puesto) (name estacion) inicio fin))
  (println "\nMovimientos registrados:" (count @historial-cambios)))

(-main)
