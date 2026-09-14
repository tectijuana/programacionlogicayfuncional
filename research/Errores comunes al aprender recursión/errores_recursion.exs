# Tema 29 — Errores comunes al aprender recursión
# Ejecutar: elixir errores_recursion.exs

defmodule RecursionSegura do
  @moduledoc """
  Ejemplos de caso base, progreso y recursión de cola.
  """

  # Caso base y caso recursivo: la longitud de la lista disminuye en cada paso.
  def suma([]), do: 0
  def suma([cabeza | cola]), do: cabeza + suma(cola)

  # La llamada recursiva es la última operación; el acumulador contiene la suma.
  def suma_cola(lista), do: suma_cola(lista, 0)
  defp suma_cola([], acumulador), do: acumulador
  defp suma_cola([cabeza | cola], acumulador), do: suma_cola(cola, acumulador + cabeza)

  # La base devuelve el acumulador; invertir al final restaura el orden original.
  def invertir(lista), do: invertir(lista, [])
  defp invertir([], acumulador), do: acumulador
  defp invertir([cabeza | cola], acumulador), do: invertir(cola, [cabeza | acumulador])

  # El error de dominio se modela explícitamente antes de iniciar la recursión.
  def dividir_cada(_lista, 0), do: {:error, :division_por_cero}
  def dividir_cada(lista, divisor), do: {:ok, dividir_cada(lista, divisor, [])}

  defp dividir_cada([], _divisor, acumulador), do: invertir(acumulador)

  defp dividir_cada([cabeza | cola], divisor, acumulador) do
    dividir_cada(cola, divisor, [cabeza / divisor | acumulador])
  end

  # EJEMPLO DEFECTUOSO (no invocar): falta la cláusula para [].
  # recorrer_sin_base([cabeza | cola]), do: [cabeza | recorrer_sin_base(cola)]
end

valores = [1, 2, 3, 4, 5]

IO.puts("suma directa: #{RecursionSegura.suma(valores)}")
IO.puts("suma de cola: #{RecursionSegura.suma_cola(valores)}")
IO.inspect(RecursionSegura.invertir(valores), label: "invertir")
IO.inspect(RecursionSegura.dividir_cada(valores, 2), label: "dividir entre 2")
IO.inspect(RecursionSegura.dividir_cada(valores, 0), label: "dividir entre 0")

