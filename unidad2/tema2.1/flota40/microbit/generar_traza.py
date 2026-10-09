#!/usr/bin/env python3
"""Genera la TRAZA estatica (caja negra) de un micro:bit y la inserta en main.py.

Uso:  python3 generar_traza.py [ORIGEN DESTINO] [--semilla N] [--sin-fallas]
      (ciudades: cdmx tijuana monterrey guadalajara merida veracruz chihuahua oaxaca tapachula culiacan)

Todo el calculo numerico (geodesia, ruido GNSS, coherencia kmh/distancia) ocurre AQUI, offline.
El micro:bit solo recorre la tabla; Erlang trata cada fix como dato opaco y lo valida.

Tiempo comprimido: 1 s de demo = FACTOR s de ruta. Distancia entre fixes = kmh * FACTOR / 3600 km.
Cada fila:  (lat*1e5, lon*1e5, kmh, hdop*10, satelites)
La tabla es ida y vuelta (ping-pong): el ultimo fix enlaza con el primero sin salto.
"""
import math, random, re, sys, os

FACTOR = 240
CIUDADES = {"cdmx": (19.43, -99.13), "tijuana": (32.51, -117.04), "monterrey": (25.67, -100.31),
            "guadalajara": (20.66, -103.35), "merida": (20.97, -89.62), "veracruz": (19.17, -96.13),
            "chihuahua": (28.63, -106.07), "oaxaca": (17.07, -96.72), "tapachula": (14.91, -92.26),
            "culiacan": (24.80, -107.39)}

def km(a, b):
    r = math.pi / 180
    h = math.sin((b[0]-a[0])*r/2)**2 + math.cos(a[0]*r)*math.cos(b[0]*r)*math.sin((b[1]-a[1])*r/2)**2
    return 12742 * math.asin(math.sqrt(h))

def generar(o, d, semilla, fallas):
    rnd = random.Random(semilla)
    total = km(o, d)
    ida, recorrido, kmh = [], 0.0, 85.0
    while recorrido < total:
        kmh = min(100, max(70, kmh + rnd.uniform(-4, 4)))        # velocidad con inercia
        recorrido = min(total, recorrido + kmh * FACTOR / 3600)
        f = recorrido / total
        lat, lon = o[0] + (d[0]-o[0])*f, o[1] + (d[1]-o[1])*f   # verdad terreno
        sats = rnd.randint(7, 11)
        hdop = round(max(0.7, 2.6 - 0.15*sats + rnd.uniform(-0.2, 0.3)), 1)
        sigma = 2.0 * hdop                                        # metros, crece con HDOP
        lat += rnd.gauss(0, sigma) / 111320
        lon += rnd.gauss(0, sigma) / (111320 * math.cos(math.radians(lat)))
        ida.append([lat, lon, round(kmh), round(hdop*10), sats])
    # vuelta: mismos puntos al reves (el ruido ya viene en cada fix)
    tabla = ida + [list(x) for x in reversed(ida[:-1])]
    if fallas and len(tabla) > 40:
        i = len(tabla)//3                                         # tunel: 5 fixes sin satelites
        for k in range(i, i+5):
            tabla[k][2:] = [0, 99, 0]
        j = len(tabla)//2                                         # fix atipico: salta ~120 km
        tabla[j][0] += 1.1
    return [(round(a*1e5), round(b*1e5), v, h, s) for a, b, v, h, s in tabla]

def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    semilla = int(sys.argv[sys.argv.index("--semilla")+1]) if "--semilla" in sys.argv else 1
    if "--semilla" in sys.argv: args.remove(str(semilla))
    o, d = (args + ["cdmx", "guadalajara"])[:2]
    tabla = generar(CIUDADES[o], CIUDADES[d], semilla, "--sin-fallas" not in sys.argv)
    bloque = "# --- TRAZA (generada por generar_traza.py %s %s, FACTOR=%d) ---\nTRAZA = (\n" % (o, d, FACTOR)
    bloque += "".join("    %r,\n" % (f,) for f in tabla) + ")\n# --- FIN TRAZA ---"
    ruta = os.path.join(os.path.dirname(os.path.abspath(__file__)), "main.py")
    src = open(ruta).read()
    nuevo = re.sub(r"# --- TRAZA.*?# --- FIN TRAZA ---", lambda m: bloque, src, flags=re.S)
    open(ruta, "w").write(nuevo)
    print("%s -> %s: %d fixes, %d bytes de tabla" % (o, d, len(tabla), len(bloque)))

if __name__ == "__main__":
    main()
