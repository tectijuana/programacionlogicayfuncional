(ns horario-server
  "Gestión de horarios TecNM con estado inmutable en Clojure.
   Usa atom para el horario actual y ref+dosync para cambios coordinados.")

;; ── Estado central ────────────────────────────────────────────
;; El horario es un mapa: {[materia salon] -> {:inicio H :fin H}}
;; Inmutable por diseño: cada cambio produce una nueva versión

(def horario-actual
  "Atom que guarda el horario vigente. Cada asig es un mapa."
  (atom {}))

(def historial-cambios
  "Registro append-only de todas las modificaciones al horario."
  (atom []))

;; ── Funciones puras ───────────────────────────────────────────

(defn- traslape?
  "Verdad si dos rangos [i1 f1] y [i2 f2] se solapan."
  [i1 f1 i2 f2]
  (and (<= i1 f2) (<= i2 f1)))

(defn conflicto?
  "Verdad si agregar la asignación nueva crea conflicto de sala/hora."
  [horario materia salon inicio fin]
  (some (fn [[[m s] {:keys [inicio-bloque fin-bloque]}]]
          (and (= s salon)
               (not= m materia)
               (traslape? inicio fin inicio-bloque fin-bloque)))
        horario))

(defn horas-materia
  "Horas semanales de cada materia según plan ISC."
  [materia]
  (get {:plf 5, :bd 5, :redes 4, :so 4,
        :ia 5, :etica 2, :ing-sw 4, :arq 3} materia))

;; ── Operaciones con efectos ───────────────────────────────────

(defn asignar!
  "Asigna una materia a un salón y bloque de inicio.
   Retorna :ok o {:error razon}."
  [materia salon inicio]
  (let [horas (horas-materia materia)
        fin   (+ inicio horas -1)]
    (cond
      (nil? horas)
      {:error :materia-desconocida}

      (or (< inicio 0) (> fin 13))
      {:error :bloque-fuera-de-rango}

      (or (= inicio 6) (= fin 6) (and (< inicio 6) (> fin 6)))
      {:error :cruza-descanso}

      (conflicto? @horario-actual materia salon inicio fin)
      {:error :conflicto-de-sala}

      :else
      (do
        (swap! horario-actual assoc [materia salon]
               {:inicio-bloque inicio :fin-bloque fin})
        (swap! historial-cambios conj
               {:accion :asignar :materia materia :salon salon
                :inicio inicio :fin fin
                :timestamp (System/currentTimeMillis)})
        :ok))))

(defn desasignar!
  "Elimina la asignación de una materia."
  [materia]
  (swap! horario-actual
         (fn [h] (into {} (remove (fn [[[m _] _]] (= m materia)) h))))
  (swap! historial-cambios conj
         {:accion :desasignar :materia materia
          :timestamp (System/currentTimeMillis)})
  :ok)

(defn horario-actual-tabla
  "Retorna el horario actual ordenado por hora de inicio."
  []
  (->> @horario-actual
       (map (fn [[[materia salon] {:keys [inicio-bloque fin-bloque]}]]
              {:materia materia
               :salon   salon
               :inicio  (+ 7 inicio-bloque)
               :fin     (+ 7 fin-bloque 1)}))
       (sort-by :inicio)))

;; ── Demo ──────────────────────────────────────────────────────

(defn -main []
  (println "=== Horario TecNM ISC — 7° Semestre ===")
  (asignar! :plf    :lab1 0)   ;; PLF: 7:00–12:00 lab1
  (asignar! :bd     :lab2 0)   ;; BD: 7:00–12:00 lab2
  (asignar! :redes  101   7)   ;; Redes: 14:00–18:00 aula 101
  (asignar! :so     102   7)   ;; SO: 14:00–18:00 aula 102
  (asignar! :etica  103   9)   ;; Ética: 16:00–18:00 aula 103
  (println "\nAsignaciones:")
  (doseq [{:keys [materia salon inicio fin]} (horario-actual-tabla)]
    (printf "  %-10s %-6s %d:00 – %d:00%n"
            (name materia) (str salon) inicio fin))
  (println "\nTotal cambios en historial:" (count @historial-cambios)))

(-main)
