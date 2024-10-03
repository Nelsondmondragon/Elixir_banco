defmodule CallDispatcher do

  def start do
    answerer1_pid = spawn(fn -> answerer(:contestador1) end)
    answerer2_pid = spawn(fn -> answerer(:contestador2) end)

    spawn(fn -> dispatcher(answerer1_pid, answerer2_pid) end)
  end

  defp answerer(name) do
    receive do
      {:call, from} ->
        IO.puts("#{name} está atendiendo una llamada.")
        :timer.sleep(1000)
        send(from, {:call_handled, name})
        answerer(name)
    end
  end

  defp dispatcher(answerer1_pid, answerer2_pid) do
    call_loop(answerer1_pid, answerer2_pid, 0)
  end

  defp call_loop(answerer1_pid, answerer2_pid, call_count) do
    :timer.sleep(2000)

    IO.puts("Generando nueva llamada número #{call_count + 1}.")

    target_pid =
      if rem(call_count, 2) == 0 do
        answerer1_pid
      else
        answerer2_pid
      end

    send(target_pid, {:call, self()})

    receive do
      {:call_handled, name} ->
        IO.puts("Despachador recibió la confirmación de que #{name} atendió la llamada.")
        call_loop(answerer1_pid, answerer2_pid, call_count + 1)
    end
  end
end
