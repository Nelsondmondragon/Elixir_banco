defmodule MyModule do
  @my_function fn x -> x * 2 end

  def get_function do
    @my_function
  end
end
