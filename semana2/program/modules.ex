# Define a module named MathOperations
defmodule MathOperations do
  @moduledoc """
  A module for basic arithmetic operations.
  """

  @doc """
  Adds two numbers.

  ## Parameters
  - a: The first number.
  - b: The second number.

  ## Examples

      iex> MathOperations.add(1, 2)
      3

  """
  def add(a, b) do
    a + b
  end

  @doc """
  Subtracts the second number from the first.

  ## Parameters
  - a: The first number.
  - b: The second number.

  ## Examples

      iex> MathOperations.subtract(5, 3)
      2

  """
  def subtract(a, b) do
    a - b
  end

  @doc """
  Multiplies two numbers.

  ## Parameters
  - a: The first number.
  - b: The second number.

  ## Examples

      iex> MathOperations.multiply(4, 3)
      12

  """
  def multiply(a, b) do
    a * b
  end

  @doc """
  Divides the first number by the second.

  ## Parameters
  - a: The first number.
  - b: The second number.

  ## Examples

      iex> MathOperations.divide(10, 2)
      5.0

  """
  def divide(a, b) do
    a / b
  end
end

# Define a module named Person
defmodule Person do
  @moduledoc """
  A module for representing and manipulating a person.
  """

  # Define a struct within the Person module
  defstruct name: "", age: 0

  @doc """
  Creates a new person.

  ## Parameters
  - name: The name of the person.
  - age: The age of the person.

  ## Examples

      iex> Person.new("Alice", 30)
      %Person{name: "Alice", age: 30}

  """
  def new(name, age) do
    %Person{name: name, age: age}
  end

  @doc """
  Updates the age of a person.

  ## Parameters
  - person: The person struct.
  - new_age: The new age to set.

  ## Examples

      iex> person = Person.new("Alice", 30)
      iex> Person.update_age(person, 31)
      %Person{name: "Alice", age: 31}

  """
  def update_age(%Person{} = person, new_age) do
    %Person{person | age: new_age}
  end

  @doc """
  Gets the name of a person.

  ## Parameters
  - person: The person struct.

  ## Examples

      iex> person = Person.new("Alice", 30)
      iex> Person.get_name(person)
      "Alice"

  """
  def get_name(%Person{} = person) do
    person.name
  end
end

# Demonstrate usage
defmodule Demo do
  def run do
    # Using MathOperations module
    IO.puts("Addition: #{MathOperations.add(1, 2)}")
    IO.puts("Subtraction: #{MathOperations.subtract(5, 3)}")
    IO.puts("Multiplication: #{MathOperations.multiply(4, 3)}")
    IO.puts("Division: #{MathOperations.divide(10, 2)}")

    # Using Person module
    person = Person.new("Alice", 30)
    IO.inspect(person)
    updated_person = Person.update_age(person, 31)
    IO.inspect(updated_person)
    IO.puts("Person's name: #{Person.get_name(updated_person)}")
  end
end

# Run the demo
Demo.run()
