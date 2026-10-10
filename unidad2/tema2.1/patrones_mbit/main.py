# micro:bit (MicroPython) — protocolo de TEXTO por USB serial, una línea por evento:
#   A:x,y,z   acelerómetro, cada 200 ms      (ej. "A:12,-40,1010")
#   T:23      temperatura en °C, cada 1 s    (ej. "T:23")
#   B:A | B:B | B:AB   botón pulsado         (ej. "B:AB")
# Lo que llegue desde la PC (una línea) se muestra en la matriz de LEDs.
from microbit import *

uart.init(baudrate=115200)
buf = b""
n = 0

while True:
    x, y, z = accelerometer.get_values()
    print("A:{},{},{}".format(x, y, z))

    if n % 5 == 0:
        print("T:{}".format(temperature()))
    n += 1

    a, b = button_a.was_pressed(), button_b.was_pressed()
    if a and b:
        print("B:AB")
    elif a:
        print("B:A")
    elif b:
        print("B:B")

    if uart.any():
        buf += uart.read()
        if b"\n" in buf:
            linea, buf = buf.split(b"\n", 1)
            display.scroll(str(linea, "utf-8"), wait=False)

    sleep(200)
