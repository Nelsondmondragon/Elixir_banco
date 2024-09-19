# Define an Employee module
defmodule Employee do
  @moduledoc """
  A module for representing and manipulating an employee.
  """

  # Define a struct within the Employee module
  defstruct name: "", position: "", salary: 0

  @doc """
  Creates a new employee.

  ## Parameters
  - name: The name of the employee.
  - position: The position of the employee.
  - salary: The salary of the employee.

  ## Examples

      iex> Employee.new("Bob", "Developer", 60000)
      %Employee{name: "Bob", position: "Developer", salary: 60000}

  """
  def new(name, position, salary) do
    %Employee{name: name, position: position, salary: salary}
  end

  @doc """
  Updates the salary of an employee.

  ## Parameters
  - employee: The employee struct.
  - new_salary: The new salary to set.

  ## Examples

      iex> employee = Employee.new("Bob", "Developer", 60000)
      iex> Employee.update_salary(employee, 65000)
      %Employee{name: "Bob", position: "Developer", salary: 65000}

  """
  def update_salary(%Employee{} = employee, new_salary) do
    %Employee{employee | salary: new_salary}
  end
end

# Define a Company module
defmodule Company do
  @moduledoc """
  A module for representing and manipulating a company.
  """

  # Define a struct within the Company module
  defstruct name: "", employees: []

  @doc """
  Creates a new company.

  ## Parameters
  - name: The name of the company.
  - employees: A list of employee structs.

  ## Examples

      iex> employees = [Employee.new("Bob", "Developer", 60000)]
      iex> Company.new("TechCorp", employees)
      %Company{name: "TechCorp", employees: [%Employee{name: "Bob", position: "Developer", salary: 60000}]}

  """
  def new(name, employees \\ []) do
    %Company{name: name, employees: employees}
  end

  @doc """
  Adds an employee to the company.

  ## Parameters
  - company: The company struct.
  - employee: The employee struct to add.

  ## Examples

      iex> company = Company.new("TechCorp")
      iex> employee = Employee.new("Alice", "Manager", 80000)
      iex> Company.add_employee(company, employee)
      %Company{name: "TechCorp", employees: [%Employee{name: "Alice", position: "Manager", salary: 80000}]}

  """
  def add_employee(%Company{} = company, %Employee{} = employee) do
    %Company{company | employees: company.employees ++ [employee]}
  end

  @doc """
  Updates the salary of an employee in the company.

  ## Parameters
  - company: The company struct.
  - employee_name: The name of the employee whose salary is to be updated.
  - new_salary: The new salary to set.

  ## Examples

      iex> company = Company.new("TechCorp", [Employee.new("Bob", "Developer", 60000)])
      iex> Company.update_employee_salary(company, "Bob", 65000)
      %Company{name: "TechCorp", employees: [%Employee{name: "Bob", position: "Developer", salary: 65000}]}

  """
  def update_employee_salary(%Company{} = company, employee_name, new_salary) do
    updated_employees = Enum.map(company.employees, fn employee ->
      if employee.name == employee_name do
        Employee.update_salary(employee, new_salary)
      else
        employee
      end
    end)
    %Company{company | employees: updated_employees}
  end
end

# Demonstrate usage
defmodule Demo do
  def run do
    # Using Employee module
    employee1 = Employee.new("Bob", "Developer", 60000)
    employee2 = Employee.new("Alice", "Manager", 80000)
    IO.inspect(employee1)
    IO.inspect(employee2)

    # Using Company module
    company = Company.new("TechCorp", [employee1])
    IO.inspect(company)
    company = Company.add_employee(company, employee2)
    IO.inspect(company)
    company = Company.update_employee_salary(company, "Bob", 65000)
    IO.inspect(company)
  end
end

# Run the demo
Demo.run()
