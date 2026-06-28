# Archivo: stream.exs
# Tema 2.4: Streams lazy en Elixir
#
# Ejecutar: elixir stream.exs
#
# En Elixir, Stream es la alternativa lazy a Enum.
# Enum.map/filter construye colecciones intermedias completas en memoria.
# Stream.map/filter construye una descripción de la transformación —
# la evaluación real ocurre solo al llamar Enum.to_list, Enum.take, etc.

# ============================================================
# Datos de ejemplo: derechohabientes IMSS (ficticios)
# En producción esto vendría de File.stream! sobre un CSV de millones de filas.
# ============================================================

defmodule Derechohabiente do
  defstruct [:nss, :nombre, :estado, :vigente, :edad, :clinica]
end

# Generador de derechohabientes ficticios
defmodule Generador do
  @estados ~w(BC BS DF GT NL QT SL VZ YN ZS)
  @nombres ~w(García López Martínez Hernández Sánchez Torres Ramírez)

  def derechohabiente(n) do
    %Derechohabiente{
      nss:     String.pad_leading("#{n}", 11, "0"),
      nombre:  Enum.at(@nombres, rem(n, length(@nombres))) <> " #{n}",
      estado:  Enum.at(@estados, rem(n, length(@estados))),
      vigente: rem(n, 7) != 0,    # ~85% vigentes
      edad:    18 + rem(n * 13, 62),
      clinica: "CMF-#{rem(n, 50) + 1}"
    }
  end
end

IO.puts("==============================================")
IO.puts(" Tema 2.4 — Streams Lazy en Elixir")
IO.puts("==============================================\n")

# ============================================================
# 1. Stream.iterate — generador infinito lazy
#    No se evalúa ningún elemento hasta que se solicita.
# ============================================================

IO.puts("--- 1. Stream.iterate: primeros 5 derechohabientes ---")

Stream.iterate(1, &(&1 + 1))
|> Stream.map(&Generador.derechohabiente/1)
|> Stream.take(5)
|> Enum.each(fn d ->
  IO.puts("  NSS: #{d.nss} | #{d.nombre} | #{d.estado} | vigente: #{d.vigente}")
end)

IO.puts("")

# ============================================================
# 2. Pipeline lazy completo — sin colecciones intermedias
#    Cada transformación describe QUÉ hacer; Enum.to_list ejecuta TODO
# ============================================================

IO.puts("--- 2. Pipeline lazy: vigentes BC o NL, edad >= 40, primeros 8 ---")

{tiempo_us, resultado} = :timer.tc(fn ->
  Stream.iterate(1, &(&1 + 1))
  |> Stream.map(&Generador.derechohabiente/1)
  |> Stream.filter(& &1.vigente)
  |> Stream.filter(& &1.estado in ["BC", "NL"])
  |> Stream.filter(& &1.edad >= 40)
  |> Stream.map(fn d -> %{d | nombre: String.upcase(d.nombre)} end)
  |> Stream.take(8)
  |> Enum.to_list()
end)

Enum.each(resultado, fn d ->
  IO.puts("  #{d.nss} | #{d.nombre} | #{d.estado} | edad: #{d.edad}")
end)

IO.puts("  Tiempo: #{tiempo_us} µs\n")

# ============================================================
# 3. Comparación: Stream vs Enum para N grande
# ============================================================

IO.puts("--- 3. Procesar 500,000 registros — Stream vs lista en memoria ---")

n = 500_000

# Con Stream — nunca crea una lista de 500k elementos
{t_stream, cuenta_stream} = :timer.tc(fn ->
  Stream.iterate(1, &(&1 + 1))
  |> Stream.map(&Generador.derechohabiente/1)
  |> Stream.filter(& &1.vigente)
  |> Stream.filter(& &1.edad > 50)
  |> Stream.take(n)
  |> Enum.count()
end)

IO.puts("  Stream: #{cuenta_stream} registros procesados en #{t_stream} µs")

# Con Enum — crea lista completa en memoria antes de filtrar
{t_enum, cuenta_enum} = :timer.tc(fn ->
  1..n
  |> Enum.map(&Generador.derechohabiente/1)
  |> Enum.filter(& &1.vigente)
  |> Enum.filter(& &1.edad > 50)
  |> Enum.count()
end)

IO.puts("  Enum:   #{cuenta_enum} registros procesados en #{t_enum} µs")
IO.puts("  Diferencia de tiempo: #{Float.round(t_enum / max(t_stream, 1), 2)}x\n")

# ============================================================
# 4. Stream.chunk_every — procesamiento por lotes (útil para BD)
# ============================================================

IO.puts("--- 4. Procesamiento por lotes de 1000 registros ---")

{t_lotes, lotes_procesados} = :timer.tc(fn ->
  Stream.iterate(1, &(&1 + 1))
  |> Stream.map(&Generador.derechohabiente/1)
  |> Stream.filter(& &1.vigente)
  |> Stream.chunk_every(1000)   # grupos de 1000 sin cargar todo en RAM
  |> Stream.map(fn lote ->
    # Simula inserción en BD por lote
    %{lote_size: length(lote), clinicas: lote |> Enum.map(& &1.clinica) |> Enum.uniq() |> length()}
  end)
  |> Stream.take(5)             # solo procesar 5 lotes (5000 registros)
  |> Enum.to_list()
end)

Enum.each(lotes_procesados, fn l ->
  IO.puts("  Lote: #{l.lote_size} registros, #{l.clinicas} clínicas distintas")
end)

IO.puts("  Tiempo total 5 lotes: #{t_lotes} µs\n")

IO.puts("==============================================")
IO.puts(" Clave: Stream describe CÓMO procesar.")
IO.puts(" Enum.to_list/Enum.take CUÁNDO procesar.")
IO.puts(" La memoria usada es proporcional al chunk, no al total.")
IO.puts("==============================================")
