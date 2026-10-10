#!/usr/bin/env bash
# Ejecuta cada llamada de las tablas de glosario.md y compara su resultado.
set -e
cd "$(dirname "$0")"
erlc verif.erl
erl -noshell -s verif main
rm -f verif.beam
