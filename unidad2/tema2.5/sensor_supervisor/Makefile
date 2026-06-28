SRCS = src/sensor_app.erl src/sensor_sup.erl src/sensor_server.erl
BEAMS = $(SRCS:.erl=.beam)

.PHONY: compile run clean demo

compile: $(BEAMS)
	@echo "Compilación exitosa."

src/%.beam: src/%.erl
	erlc -o src/ $<

run: compile
	@echo "Iniciando sistema de sensores IoT..."
	@echo "Presiona Ctrl+C dos veces para salir."
	erl -pa src/ -eval "application:start(sensor_app)" -noshell

demo: compile
	@echo "Demo interactivo — abre la shell de Erlang con el sistema corriendo."
	erl -pa src/ -eval "application:start(sensor_app)"

clean:
	rm -f src/*.beam
	@echo "Limpieza completada."
