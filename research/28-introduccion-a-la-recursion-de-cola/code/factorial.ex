defmodule Factorial do
  @moduledoc """
  Comparación entre recursión normal y recursión de cola.
  """

  # Recursión normal (NO tail-recursive)
  def normal(0), do: 1
  def normal(n) when n > 0, do: n * normal(n - 1)

  # Recursión de cola (tail-recursive)
  def tail(n), do: tail(n, 1)

  defp tail(0, acc), do: acc
  defp tail(n, acc) when n > 0, do: tail(n - 1, n * acc)
end

# Demostración
IO.puts("=== Factorial: Recursión Normal vs Recursión de Cola ===")
IO.puts("")

for n <- [0, 1, 5, 10, 20] do
  IO.puts("factorial(#{n})")
  IO.puts("  Normal : #{Factorial.normal(n)}")
  IO.puts("  Cola   : #{Factorial.tail(n)}")
  IO.puts("")
end
