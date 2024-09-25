defmodule Empresa do
  @moduledoc """
  This module contains the Employee struct and related functions.

  ## Special Symbols
  - `defmodule`: Defines a new module
  - `@moduledoc`: Provides documentation for the module
  """

  defmodule Employee do
    @moduledoc """
    Defines the Employee struct with common attributes.

    ## Special Symbols
    - `defmodule`: Defines a nested module
    - `@moduledoc`: Provides documentation for the module
    - `@enforce_keys`: Specifies which keys must be set when creating a new struct
    - `defstruct`: Defines a struct with the specified fields
    - `@type`: Defines a custom type for the struct
    """

    @enforce_keys [:name, :position]
    # This line tells Jason (a JSON encoder/decoder library) to only encode the specified fields
    # when converting an Employee struct to JSON. This is useful for controlling which data
    # is included in API responses or when writing to JSON files.
    #
    # Examples:
    # 1. Including all fields:
    #    @derive Jason.Encoder
    #
    # 2. Excluding specific fields:
    #    @derive {Jason.Encoder, except: [:salary]}
    #
    @derive {Jason.Encoder, only: [:id, :name, :position, :email, :phone, :hire_date, :salary]}
    defstruct [:id, :name, :position, :email, :phone, :hire_date, :salary]

    # This defines a custom type 't' for the Employee struct:
    # @type: Specifies a type
    # t: The name of the type (often used to represent the main type of a module)
    # %__MODULE__{}: Refers to the current module's struct
    # Each field is defined with its type:
    #   - integer() | nil: Can be an integer or nil
    #   - String.t(): Elixir's string type
    #   - Date.t(): Elixir's date type
    #   - float(): A floating-point number
    # The | nil syntax indicates that the field is optional
    @type t :: %__MODULE__{
      id: integer() | nil,
      name: String.t(),
      position: String.t(),
      email: String.t() | nil,
      phone: String.t() | nil,
      hire_date: Date.t() | nil,
      salary: float() | nil
    }

    @doc """
    Creates a new Employee struct.

    ## Parameters
    - `name`: String, the employee's name (required)
    - `position`: String, the employee's job position (required)
    - `opts`: Keyword list of optional attributes (optional)

    ## Returns
    - `%Empresa.Employee{}`: A new Employee struct

    ## Special Symbols
    - `@doc`: Provides documentation for the function
    - `def`: Defines a public function
    - `\\\\`: Default argument separator
    - `__MODULE__`: Refers to the current module
    - `!`: In `struct!`, raises an error if required keys are missing

    ## Examples
        iex> Empresa.Employee.new("John Doe", "Developer")
        %Empresa.Employee{name: "John Doe", position: "Developer"}
    """
    def new(name, position, opts \\ []) do
      struct!(__MODULE__, [name: name, position: position] ++ opts)
    end
  end
end

# MIX in Elixir:
# Mix is Elixir's built-in build tool and project management system.
# It provides tasks for creating, compiling, testing, and managing dependencies
# for Elixir projects. Mix also generates the project structure and helps
# maintain consistent organization across Elixir applications and libraries.

# To run a task, use the mix command in the terminal:
# mix <task>

# Some common Mix tasks:
# - mix new: Creates a new Elixir project
# - mix compile: Compiles the project
# - mix test: Runs the tests
# - mix run: Runs the project

# To create a new Elixir project, use:
# mix new <project_name>

# This creates a new directory with the project name and sets up a basic project structure.

##Folder structure:

# A typical Elixir project structure created by Mix:
#
# empresa/                 # Root project directory
# ├── .formatter.exs       # Formatter configuration for consistent code style
# ├── .gitignore           # Specifies intentionally untracked files to ignore
# ├── README.md            # Project documentation and information
# ├── mix.exs              # Project configuration, dependencies, and metadata
# ├── lib/                 # Main source code directory
# │   ├── empresa.ex       # Main module, often shares name with project
# │   └── reader.ex        # Module for reading employee data
# ├── test/                # Test files directory
# │   ├── test_helper.exs  # Test configuration and helpers
# │   └── empresa_test.exs # Tests for the main module
# └── config/              # Configuration files for different environments
#     └── config.exs       # Main configuration file
#
# Key components:
# - lib/: Contains the main source code of the application
#   - empresa.ex: Defines the core functionality and data structures
#   - reader.ex: Handles reading operations for employee data
# - test/: Houses all test files to ensure code correctness
# - config/: Stores configuration files for various environments
# - mix.exs: Central file for project setup, dependencies, and tasks
#
# This structure promotes organization, separation of concerns,
# and follows Elixir community best practices for project layout.

# To add a dependency to your project, edit the `mix.exs` file:
# defp deps do
#   [{:jason, "~> 1.4"}]
# end

# This adds the Jason library to your project with a version constraint.

## command to run the project:
# Start the interactive Elixir shell with the project loaded
# iex -S mix

# # Create new employees
# employee1 = Empresa.Employee.new("John Doe", "Developer", email: "john@example.com", salary: 75000.0)
# employee2 = Empresa.Employee.new("Jane Smith", "Manager", phone: "555-1234", hire_date: ~D[2023-01-15])

# # Write employees to JSON file
# Writer.write_employee(employee1)
# Writer.write_employee(employee2)

# # Read all employees
# all_employees = Reader.read_all_employees()

# # Read a specific employee by ID
# {:ok, found_employee} = Reader.read_employee_by_id(1)
# {:error, :not_found} = Reader.read_employee_by_id(999)

# # Create more employees with different attributes
# employee3 = Empresa.Employee.new("Bob Johnson", "Designer", email: "bob@example.com", phone: "555-5678")
# employee4 = Empresa.Employee.new("Alice Brown", "HR Specialist", salary: 65000.0, hire_date: ~D[2022-09-01])

# # Write these new employees
# Writer.write_employee(employee3)
# Writer.write_employee(employee4)

# # Read all employees again to see the updates
# updated_employees = Reader.read_all_employees()

# # Try reading employees by different IDs
# {:ok, employee2} = Reader.read_employee_by_id(2)
# {:ok, employee4} = Reader.read_employee_by_id(4)

# # Attempt to read a non-existent employee
# {:error, :not_found} = Reader.read_employee_by_id(10)
