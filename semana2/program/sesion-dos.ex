defmodule Playground do
  calcular = fn
    :circulo ->
      IO.puts("La figura es un circulo")
    :cuadrado ->
      IO.puts("La figura es un cuadrado")
    :triangulo ->
      IO.puts("La figura es un triangulo")
    :diamante ->
      IO.puts("La figura es un dimante")
    figura ->
      {:error, figura}
  end
end
