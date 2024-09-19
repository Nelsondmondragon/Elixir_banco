defmodule Playground do
  def test(x) when is_number(x) and x < 0 do
    :negativo
  end

  def test(0), do: :cero

  def test(x) when is_number(x) and x > 0 do
    :positivo
  end

  def test(_x) do
    :Nann
  end

  def max(a, b) when is_number(a) and is_number(b) do
    case a > b do
      true -> a
      false -> b
    end
  end
  def max(a, b) do
    :nann
  end

  def createUser_public(params) do
    with {:ok, user} <- createUser(params),
        {:ok, result} <- sendEmail(user),
        {:ok, message} <- logInfo(user,result) do
          {:ok, user}
        else
          {:error, reason} -> {:error, reason}
        end
  end

  #%{username: "juan@gmail.com", password: "123456"}
  defp createUser(params) do
    IO.inspect(params)
    {:ok, params.username}
  end

  defp sendEmail(username) do
    IO.puts("Enviando email a #{username}")
    IO.inspect(username)
    {:ok, "Email enviado"}
  end

  defp logInfo(user, result) do
    IO.puts("usuario creado: #{user} y resultado del envío de email: #{result}")
    {:ok, "usuario creado"}
  end
end
