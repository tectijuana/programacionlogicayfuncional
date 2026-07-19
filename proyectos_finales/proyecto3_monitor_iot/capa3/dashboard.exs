# =====================================================================
# Programa:    dashboard.exs
# Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
# Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
# Actividad:   Proyecto Final P3 — Monitor IoT CENAPRED, capa 3
# Fecha:       2026-07-18
# Descripción: Dashboard de lecturas en consola con Elixir Stream
# IA:          Generado con Claude Code, verificado y modificado por el docente
# =====================================================================
defmodule Dashboard do
  @moduledoc """
  Dashboard de monitoreo IoT CENAPRED usando Elixir Stream.
  Procesa lecturas de sensores de forma lazy — nunca carga todo en memoria.
  """

  @sensores [:sismico, :temperatura, :humedad, :co2, :presion]

  @umbrales %{
    sismico:     %{alerta: 39, critico: 60},
    temperatura: %{alerta: 34, critico: 40},
    humedad:     %{alerta: 21, critico: 10, invertido: true},
    co2:         %{alerta: 999, critico: 2000},
    presion:     %{alerta: 951, critico: 920, invertido: true}
  }

  def clasificar(sensor, lectura) do
    config = @umbrales[sensor]
    invertido = Map.get(config, :invertido, false)

    cond do
      invertido and lectura <= config.critico -> :critico
      invertido and lectura <= config.alerta  -> :alerta
      not invertido and lectura >= config.critico -> :critico
      not invertido and lectura >= config.alerta  -> :alerta
      true -> :normal
    end
  end

  def simular_lectura(:sismico),     do: :rand.uniform(80)
  def simular_lectura(:temperatura), do: 20 + :rand.uniform(25)
  def simular_lectura(:humedad),     do: 5  + :rand.uniform(80)
  def simular_lectura(:co2),         do: 300 + :rand.uniform(2000)
  def simular_lectura(:presion),     do: 900 + :rand.uniform(130)

  def icono(:normal),  do: "✓"
  def icono(:alerta),  do: "⚠"
  def icono(:critico), do: "✗"

  def imprimir_lectura({sensor, lectura, nivel}) do
    IO.puts("  #{icono(nivel)} #{String.pad_trailing(to_string(sensor), 12)} #{lectura}\t[#{nivel}]")
  end

  def ciclo_lectura(_n) do
    @sensores
    |> Enum.map(fn s -> {s, simular_lectura(s)} end)
    |> Enum.map(fn {s, v} -> {s, v, clasificar(s, v)} end)
  end

  def run(ciclos \\ :infinity) do
    IO.puts("\n=== Monitor IoT CENAPRED — Dashboard ===\n")

    Stream.iterate(1, &(&1 + 1))
    |> stream_take(ciclos)
    |> Stream.map(fn n ->
      IO.puts("── Ciclo #{n} ──────────────────────────")
      lecturas = ciclo_lectura(n)
      Enum.each(lecturas, &imprimir_lectura/1)
      nivel_global = lecturas |> Enum.map(&elem(&1, 2)) |> nivel_maximo()
      IO.puts("   Estado global: #{nivel_global}\n")
      :timer.sleep(1500)
      lecturas
    end)
    |> Stream.run()
  end

  defp nivel_maximo(niveles) do
    cond do
      :critico in niveles -> :CRITICO
      :alerta  in niveles -> :ALERTA
      true                -> :normal
    end
  end

  defp stream_take(stream, :infinity), do: stream
  defp stream_take(stream, n),         do: Stream.take(stream, n)
end

Dashboard.run(5)
