#!/usr/bin/env python3
"""Emula un micro:bit para probar main.py SIN hardware (stdin/stdout = el puerto serial).
Uso: python3 emulador.py [--rapido]      (--rapido: sleep x10 para pruebas)
Botones simulados: lineas '@A', '@B', '@L' (logo) por stdin. Lo demas lo recibe uart.read().
Se usa desde Erlang con la fuente {cmd, "python3 microbit/emulador.py"} de semi_serial.
"""
import sys, os, types, time, select

sys.stdout.reconfigure(line_buffering=True)
rapido = "--rapido" in sys.argv
pend = {"a": False, "b": False, "l": False}
bufin = bytearray()

def _leer():
    while select.select([sys.stdin], [], [], 0)[0]:
        d = os.read(sys.stdin.fileno(), 4096)
        if not d:
            sys.exit(0)                      # cable desconectado
        bufin.extend(d)
    while b"\n" in bufin:                    # separa los botones simulados de lo que ve uart
        i = bufin.index(b"\n"); linea = bytes(bufin[:i]); 
        if linea.strip()[:1] == b"@":
            pend[linea.strip()[1:2].lower().decode()] = True
            del bufin[:i+1]
        else:
            break

class Boton:
    def __init__(s, k): s.k = k
    def was_pressed(s): _leer(); v = pend[s.k]; pend[s.k] = False; return v
class Pin:
    def is_touched(s): _leer(); v = pend["l"]; pend["l"] = False; return v
class Uart:
    def init(s, **kw): pass
    def any(s): _leer(); return len(bufin) > 0 and b"\n" in bufin
    def read(s): d = bytes(bufin); bufin.clear(); return d
class Display:
    def show(s, x): sys.stderr.write("[LED] %s\n" % (x,))
    def scroll(s, t, wait=True): sys.stderr.write("[LED] scroll %r\n" % t)
class Img:
    def __getattr__(s, n): return n
m = types.ModuleType("microbit")
m.button_a, m.button_b, m.pin_logo = Boton("a"), Boton("b"), Pin()
m.uart, m.display, m.Image = Uart(), Display(), Img()
m.accelerometer = types.SimpleNamespace(was_gesture=lambda g: False)
m.sleep = lambda ms: time.sleep(ms / 1000 / (10 if rapido else 1))
sys.modules["microbit"] = m

src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "main.py")).read()
exec(compile(src, "main.py", "exec"), {"__name__": "__main__"})
