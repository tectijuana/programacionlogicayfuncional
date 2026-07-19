# =====================================================================
# Programa:    curp_imperativo.py
# Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
# Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
# Actividad:   Tema 1.3 — Comparación de paradigmas
# Fecha:       2026-07-18
# Descripción: Validador de CURP en paradigma imperativo/OOP (contraste con Erlang y Prolog)
# IA:          Generado con Claude Code, verificado y modificado por el docente
# =====================================================================
"""
curp_imperativo.py — Validador de CURP mexicana, paradigma OOP/imperativo.
Cómo correr: python3 curp_imperativo.py
"""

ESTADOS_VALIDOS = {
    "AS", "BC", "BS", "CC", "CL", "CM", "CS", "DF", "DG",
    "GR", "GT", "HG", "JC", "MC", "MN", "MS", "NT", "NL",
    "OC", "PL", "QO", "QR", "SP", "SL", "SR", "TC", "TS",
    "TL", "VZ", "YN", "ZS",
}


class ValidadorCURP:
    """Valida y extrae datos de una CURP mexicana."""

    def __init__(self, curp: str):
        self.curp = curp.upper().strip()
        self.errores: list[str] = []
        self._valido: bool | None = None

    def validar(self) -> bool:
        self.errores = []
        self._valida_longitud()
        self._valida_sexo()
        self._valida_estado()
        self._valido = len(self.errores) == 0
        return self._valido

    def _valida_longitud(self) -> None:
        if len(self.curp) != 18:
            self.errores.append(
                f"Longitud inválida: se esperan 18 caracteres, se recibieron {len(self.curp)}"
            )

    def _valida_sexo(self) -> None:
        if len(self.curp) >= 11:
            sexo = self.curp[10]
            if sexo not in ("H", "M"):
                self.errores.append(
                    f"Sexo inválido en posición 11: '{sexo}'. Se esperaba H o M."
                )

    def _valida_estado(self) -> None:
        if len(self.curp) >= 13:
            estado = self.curp[11:13]
            if estado not in ESTADOS_VALIDOS:
                self.errores.append(
                    f"Estado inválido en posiciones 12-13: '{estado}'."
                )

    def extraer_fecha(self) -> dict | None:
        if len(self.curp) < 10:
            return None
        try:
            anio = int(self.curp[4:6])
            mes = int(self.curp[6:8])
            dia = int(self.curp[8:10])
            return {"año": anio, "mes": mes, "dia": dia}
        except ValueError:
            return None

    def extraer_sexo(self) -> str | None:
        if len(self.curp) >= 11:
            return "Hombre" if self.curp[10] == "H" else "Mujer"
        return None

    def extraer_estado(self) -> str | None:
        if len(self.curp) >= 13:
            return self.curp[11:13]
        return None

    def reporte(self) -> None:
        print(f"\nCURP: {self.curp}")
        if self._valido is None:
            self.validar()
        if self._valido:
            fecha = self.extraer_fecha()
            print("  Estado: VÁLIDA")
            print(f"  Fecha de nacimiento: {fecha['dia']:02d}/{fecha['mes']:02d}/{fecha['año']:02d}")
            print(f"  Sexo:   {self.extraer_sexo()}")
            print(f"  Estado: {self.extraer_estado()}")
        else:
            print("  Estado: INVÁLIDA")
            for error in self.errores:
                print(f"  ✗ {error}")


def demo():
    casos = [
        "SAOA800115HBCNND05",   # válida
        "GACF850320MMCNRR09",   # válida
        "CORTO",                 # longitud inválida
        "SAOA800115XBCNND05",   # sexo inválido (X)
        "SAOA800115HXX NND05",  # estado inválido (XX)
    ]
    for curp in casos:
        v = ValidadorCURP(curp)
        v.validar()
        v.reporte()


if __name__ == "__main__":
    demo()
