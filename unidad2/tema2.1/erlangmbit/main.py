# micro:bit (MicroPython) — envía "x,y,z,temp" por USB serial cada 200 ms
# y muestra en los LEDs el texto que llegue desde la PC (una línea por mensaje).
from microbit import *

uart.init(baudrate=115200)
buf = b""

while True:
    x, y, z = accelerometer.get_values()
    print("{},{},{},{}".format(x, y, z, temperature()))

    if uart.any():
        buf += uart.read()
        if b"\n" in buf:
            linea, buf = buf.split(b"\n", 1)
            display.scroll(str(linea, "utf-8"), wait=False)

    sleep(200)
