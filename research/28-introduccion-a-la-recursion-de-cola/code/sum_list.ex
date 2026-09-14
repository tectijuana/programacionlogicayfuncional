defmodule SumList do
  @moduledoc """
  Suma de lista con recursión de cola.
  """

  # Recursión normal (NO tail-recursive)
  def normal([]), do: 0
  def normal([h | t]), do: h + normal(t)

  # Recursión de cola (tail-recursive con acumulador)
  def tail(list), do: tail(list, 0)

  defp tail([], acc), do: acc
  defp tail([h | t], acc), do: tail(t, h + acc)
end

# Demostración
IO.puts("=== Suma de Lista: Recursión Normal vs Recursión de Cola ===")
IO.puts("")

listas = [
  [1, 2, 3],
  [10, 20, 30, 40],
  Enum.to_list(1..1000)
]

for lista <- listas do
  contenido = lista |> Enum.take(5) |> inspect()
  longitud = length(lista)

  if longitud > 5 do
    IO.puts("Lista: #{contenido}... (#{longitud} elementos)")
  else
    IO.puts("Lista: #{inspect(lista)}")
  end

  IO.puts("  Normal : #{SumList.normal(lista)}")
  IO.puts("  Cola   : #{SumList.tail(lista)}")
  IO.puts("")
end

# Prueba con lista grande (aquí la recursión normal podría fallar)
grande = Enum.to_list(1..100_000)
IO.puts("Lista de #{length(grande)} elementos:")
IO.puts("  Suma con recursión de cola: #{SumList.tail(grande)}")
IO.puts("  (La recursión normal con esta lista causaría stack overflow)")
