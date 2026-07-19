# 1 · asciinema — grabación de sesiones de terminal

Guía autocontenida para instalar, usar y grabar correctamente sesiones de
terminal con **asciinema**. El curso usa estas grabaciones como evidencia de
las prácticas: cada entrega de instalación (Prolog, Erlang, Haskell, Clojure,
Elixir, OCaml, Raspberry Pi) debe acompañarse de un `.cast` publicado en
[asciinema.org](https://asciinema.org).

## ¿Por qué asciinema y no un video de pantalla?

- Graba **texto**, no píxeles: los archivos `.cast` pesan kilobytes, no
  megabytes.
- El resultado es **reproducible y copiable** — quien lo ve puede seleccionar
  y copiar comandos directamente del reproductor embebido.
- No expone audio/video de tu escritorio: solo lo que ocurre en el
  terminal, ideal para evidencia académica sin fricciones de privacidad.

## Instalación

### Opción A — apt (Ubuntu 24.04 ARM64/AMD64, recomendada)

```bash
sudo apt update
sudo apt install -y asciinema
asciinema --version
```

### Opción B — pip (si necesitas la última versión)

```bash
sudo apt install -y pipx
pipx install asciinema
pipx ensurepath
# cierra y reabre la sesión SSH para que el PATH tome efecto
asciinema --version
```

### Opción C — macOS (Homebrew, para practicar localmente)

```bash
brew install asciinema
```

## Paso 1 — Autenticar tu cuenta (una sola vez por máquina)

Para que tus grabaciones queden asociadas a tu cuenta de asciinema.org (y
puedas editar título/descripción después de publicar):

```bash
asciinema auth
```

Esto imprime una URL. Ábrela en tu navegador y confirma con tu cuenta de
asciinema.org (puedes crear una gratis con GitHub/GitLab/correo). Sin este
paso, las grabaciones se publican como **anónimas** y no podrás editarlas ni
borrarlas después.

## Paso 2 — Grabar una sesión

```bash
asciinema rec practica-prolog.cast
```

- **Primer comando obligatorio de TODA grabación — identifícate antes de
  teclear cualquier otra cosa:**

  ```bash
  echo "Programa XYZ, por XXXX de curso YYYY Horario 999 actividad ZZZZ"
  ```

  (Sustituye: nombre del programa, tu nombre y no. de control, curso, horario y
  actividad.) Una grabación que no abre con su identificación **no es válida
  como evidencia** del curso.
- Después escribe tus comandos con normalidad.
- Para **terminar la grabación**: `Ctrl+D` o escribe `exit`.
- El archivo `.cast` queda guardado localmente en el directorio actual.

### Buenas prácticas para grabar

| Práctica | Por qué |
|----------|---------|
| Limpia la pantalla antes de empezar (`clear`) | El video queda limpio desde el segundo 0 |
| Usa `PS1` corto (evita prompts con rutas larguísimas) | Se ve mejor en el reproductor embebido |
| No grabes contraseñas ni tokens en pantalla | El `.cast` es texto plano — cualquiera que lo vea puede leerlos |
| Explica en voz de comentarios (`echo "== paso 2: instalar swipl =="`) | Da contexto a quien revisa sin necesitar audio |
| Evita `cat` de archivos gigantes o `htop` interactivo prolongado | Infla el archivo y aburre al revisor |
| Idle time se comprime automáticamente | No necesitas preocuparte por pausas — usa `-i` si quieres forzarlo (ver abajo) |

Grabación con límite de tiempo muerto (colapsa pausas mayores a 2 segundos,
útil si te quedas pensando o copiando comandos largos):

```bash
asciinema rec -i 2 practica-prolog.cast
```

Grabar con título y idle-time máximo desde el inicio:

```bash
asciinema rec -i 2 -t "Instalación SWI-Prolog 9.x en EC2 ARM64" practica-prolog.cast
```

## Paso 3 — Reproducir localmente (verificar antes de publicar)

```bash
asciinema play practica-prolog.cast
```

Revisa que:
- Los comandos clave (instalación, verificación de versión, prueba
  interactiva) se vean completos y sin cortes.
- No haya credenciales, IPs privadas sensibles ni rutas personales expuestas.

## Paso 4 — Publicar en asciinema.org

```bash
asciinema upload practica-prolog.cast
```

Esto imprime una URL pública, por ejemplo:

```
https://asciinema.org/a/abcdefghijklmnop
```

> Si no corriste `asciinema auth` en el Paso 1, el upload queda anónimo. Aun
> así obtienes la URL — cópiala de inmediato porque no podrás recuperarla
> desde tu cuenta después.

> ⚠️ **Regla de los 7 días:** una grabación subida sin reclamar (no asociada a
> una cuenta) **se elimina de asciinema.org a los 7 días**. Reclámala de
> inmediato: corre `asciinema auth` antes del upload, o abre la URL con tu
> sesión iniciada y asóciala a tu cuenta. Una evidencia borrada = entrega sin
> evidencia (0 en el criterio de demostración).

## Paso 5 — Reclamar, documentar y elegir visibilidad en asciinema.org

Una vez publicado, entra a la URL del cast (con tu sesión iniciada) y pulsa
**Edit**. Ahí también eliges la **visibilidad** del enlace:

- **Público** — aparece listado en tu perfil de asciinema.org (útil como portafolio).
- **Privado / unlisted** — solo lo ve quien tenga el enlace; suficiente para el
  curso, pues la URL va en la descripción de tu Pull Request.

Cualquiera de las dos es válida como evidencia. Después **documenta
profesionalmente qué estás demostrando**:

- **Title**: identifica sesión y software, p.ej. `Prolog 9.x — instalación y prueba CLP(FD) (Equipo 3)`
- **Description**: agrega contexto que no cabe en el terminal:
  - Nombre del alumno/equipo y materia (Programación Lógica y Funcional).
  - Fecha y entorno usado (EC2 Graviton ARM64 / Raspberry Pi Zero 2W).
  - Qué guía de `instalacion/` siguió (enlaza el `.md` correspondiente de este
    repositorio).
  - Cualquier desviación relevante del procedimiento estándar (por ejemplo,
    si usó la Opción B en vez de la Opción A).

Ejemplo de descripción:

```
Instalación de SWI-Prolog 9.0.4 en instancia EC2 t4g.micro (Ubuntu 24.04 ARM64),
siguiendo instalacion/02_prolog.md del curso Programación Lógica y Funcional
(TecNM Tijuana). Incluye prueba interactiva de CLP(FD). Grabado 2026-07-16.
```

## Paso 6 — Entregar el enlace

Pega la URL pública (`https://asciinema.org/a/...`) en la plataforma de
entrega del curso (o en el README de tu repositorio de prácticas). No
entregues el archivo `.cast` por separado — la URL ya lo aloja y lo hace
reproducible sin instalar nada.

## Comandos de referencia rápida

```bash
asciinema auth                          # vincula esta máquina a tu cuenta
asciinema rec archivo.cast              # graba
asciinema rec -i 2 -t "Título" a.cast   # graba con idle-limit y título
asciinema play archivo.cast             # reproduce localmente
asciinema upload archivo.cast           # publica y obtiene URL
asciinema cat archivo.cast              # reimprime la sesión sin timing (como un log)
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `asciinema: command not found` | Repite instalación (Opción A o B); si usaste `pipx`, corre `pipx ensurepath` y reabre la sesión |
| `upload` falla con error de red | La instancia EC2 necesita salida a internet (verifica el Security Group del Paso 3 en [00_aws_academy_cloudshell.md](00_aws_academy_cloudshell.md)) |
| El cast quedó anónimo y ya no lo encuentras | No había `asciinema auth` previo; guarda la URL apenas hagas `upload`, no se puede recuperar por cuenta después |
| La URL de la grabación ya no existe | No se reclamó dentro de los **7 días** — asciinema.org la eliminó; vuelve a grabar y esta vez corre `asciinema auth` antes de subir |
| El archivo `.cast` es enorme | Evita `cat` de archivos grandes o procesos interactivos largos (`htop`, `top`) durante la grabación; usa `-i 2` |
| Quiero borrar una grabación pública | Solo si estás autenticado: entra a la URL → **Edit** → **Delete** |
