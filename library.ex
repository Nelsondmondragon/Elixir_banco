defmodule Library do
  @moduledoc """
  A module for managing a library system with books and users.
  """

  defmodule Book do
    @moduledoc """
    A struct representing a book in the library.
    """
    defstruct title: "", author: "", isbn: "", available: true
  end

  defmodule User do
    @moduledoc """
    A struct representing a user of the library.
    """
    defstruct name: "", id: "", borrowed_books: []
  end

  @doc """
  Adds a book to the library.

  ## Parameters
  - library: The current list of books in the library.
  - book: The book struct to add.



  ## Examples

      iex> library = []
      iex> book = %Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}
      iex> Library.add_book(library, book)
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}]
  """
  def add_book(library, %Book{} = book) do
    library ++ [book]
  end

  @doc """
  Adds a user to the library system.

  ## Parameters
  - users: The current list of users.
  - user: The user struct to add.

  ## Examples

      iex> users = []
      iex> user = %Library.User{name: "Alice", id: "1"}
      iex> Library.add_user(users, user)
      [%Library.User{name: "Alice", id: "1", borrowed_books: []}]
  """
  def add_user(users, %User{} = user) do
    users ++ [user]
  end

  @doc """
  Allows a user to borrow a book from the library.

  ## Parameters
  - library: The current list of books in the library.
  - users: The current list of users.
  - user_id: The ID of the user borrowing the book.
  - isbn: The ISBN of the book to borrow.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}]
      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: []}]
      iex> Library.borrow_book(library, users, "1", "1234567890")
      {:ok, [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}], [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]}]}
  """
  def borrow_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(library, &(&1.isbn == isbn && &1.available))

    cond do
      user == nil ->
        {:error, "Usuario no encontrado"}

      book == nil ->
        {:error, "Libro no disponible"}

      true ->
        updated_book = %{book | available: false}
        updated_user = %{user | borrowed_books: user.borrowed_books ++ [updated_book]}

        updated_library =
          Enum.map(library, fn
            b when b.isbn == isbn -> updated_book
            b -> b
          end)

        updated_users =
          Enum.map(users, fn
            u when u.id == user_id -> updated_user
            u -> u
          end)

        {:ok, updated_library, updated_users}
    end
  end

  @doc """
  Allows a user to return a borrowed book to the library.

  ## Parameters
  - library: The current list of books in the library.
  - users: The current list of users.
  - user_id: The ID of the user returning the book.
  - isbn: The ISBN of the book to return.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]
      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]}]
      iex> Library.return_book(library, users, "1", "1234567890")
      {:ok, [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}], [%Library.User{name: "Alice", id: "1", borrowed_books: []}]}
  """
  def return_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(user.borrowed_books, &(&1.isbn == isbn))

    cond do
      user == nil ->
        {:error, "Usuario no encontrado"}

      book == nil ->
        {:error, "Libro no encontrado en los libros prestados del usuario"}

      true ->
        updated_book = %{book | available: true}

        updated_user = %{
          user
          | borrowed_books: Enum.filter(user.borrowed_books, &(&1.isbn != isbn))
        }

        updated_library =
          Enum.map(library, fn
            b when b.isbn == isbn -> updated_book
            b -> b
          end)

        updated_users =
          Enum.map(users, fn
            u when u.id == user_id -> updated_user
            u -> u
          end)

        {:ok, updated_library, updated_users}
    end
  end

  @doc """
  Lists all books in the library.

  ## Parameters
  - library: The current list of books in the library.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
      iex> Library.list_books(library)
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
  """
  def list_book(library) do
    library
  end

  def list_books_io(library) do
    Enum.each(library, fn %Book{title: title, author: author, isbn: isbn, available: available} ->
      IO.puts("Título: #{title}, Autor: #{author}, ISBN: #{isbn}, Disponible: #{available}")
    end)
  end

  @doc """
  Lists all users in the library system.

  ## Parameters
  - users: The current list of users.

  ## Examples

      iex> users = [%Library.User{name: "Alice", id: "1"}]
      iex> Library.list_users(users)
      [%Library.User{name: "Alice", id: "1"}]
  """
  def list_users(users) do
    users
  end

  def list_users_io(users) do
    Enum.each(users, fn %User{name: name, id: id} ->
      IO.puts("Usuario: #{name}, ID: #{id}")
    end)
  end

  @doc """
  Lists all books borrowed by a specific user.

  ## Parameters
  - users: The current list of users.
  - user_id: The ID of the user whose borrowed books are to be listed.

  ## Examples

      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]}]
      iex> Library.books_borrowed_by_user(users, "1")
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
  """
  def books_borrowed_by_user(users, user_id) do
    user = Enum.find(users, &(&1.id == user_id))
    if user, do: user.borrowed_books, else: []
  end

  def list_borrowed_books_io(users, user_id) do
    user = Enum.find(users, fn %User{id: id} -> id == user_id end)

    if user do
      Enum.each(user.borrowed_books, fn %Book{title: title, isbn: isbn} ->
        IO.puts("Libro: #{title}, ISBN: #{isbn}")
      end)
    else
      IO.puts("El usuario no existe.")
    end
  end

  @doc """
  Listar todos los libros disponibles en la biblioteca

  ## Parameters
  - library: The current list of books in the library.

  """
  def books_available(library) do
    available_books = Enum.filter(library, fn %Book{available: available} -> available end)
    list_books_io(available_books)
  end

  @doc """
  Verificar la disponibilidad de un libro por ISBN

  ## Parameters
  - library: The current list of books in the library.
  - book_isbn: Isbn del libro a buscar

  """
  def book_available_by_isbn(library, book_isbn) do
    book =
      Enum.find(library, fn %Book{isbn: isbn} ->
        isbn == book_isbn
      end)

    if book do
      mensaje = "El libro '#{book.title}' con ISBN #{book_isbn} está disponible."
      IO.puts(mensaje)
    else
      mensaje = "El libro con ISBN #{book_isbn} no está disponible."
      IO.puts(mensaje)
    end
  end

  @doc """
  Eliminar un libro de la coleccion, validando que el libro no este en
  la lista de libros de un usuario,tambien se puedo validando el estado del libro

  ## Parameters
  - library: The current list of books in the library.
  - book_isbn: libro a eliminar
  """
  def delete_book(library, users, %Book{} = book_delete) do
    user_book =
      Enum.find(users, fn %User{borrowed_books: borrowed_books} ->
        Enum.find(borrowed_books, fn %Book{isbn: isbn} -> isbn == book_delete.isbn end)
      end)

    if user_book do
      library
    else
      book =
        Enum.find(library, fn %Book{isbn: isbn} ->
          book_delete.isbn == isbn
        end)

      case book do
        _book -> library -- [book]
        nil -> library
      end
    end
  end

  @doc """
  Buscar libros por autor

  ## Parameters
  - library: The current list of books in the library.
  - book_isbn: libro a eliminar
  """
  def search_books(library, author_search) do
    books =
      Enum.filter(library, fn %Book{author: author} ->
        String.contains?(String.downcase(author), String.downcase(author_search))
      end)

    list_books_io(books)
  end

  def run do
    book1 = %Library.Book{
      title: "Elixir in Action",
      author: "Sasa Juric",
      isbn: "9781617295027",
      available: true
    }

    book2 = %Library.Book{
      title: "Programming Elixir",
      author: "Dave Thomas",
      isbn: "9781680502992",
      available: false
    }

    book3 = %Library.Book{
      title: "The Pragmatic Programmer",
      author: "Andrew Hunt, David Thomas",
      isbn: "9780201616224",
      available: true
    }

    user1 = %Library.User{
      name: "Juan Pérez",
      id: "12345",
      # Juan tiene el libro "Elixir in Action"
      borrowed_books: [book2]
    }

    library = []
    users = []

    users = Library.add_user(users, user1)
    library = Library.add_book(library, book1)
    library = Library.add_book(library, book2)
    library = Library.add_book(library, book3)

    IO.puts("Books available")
    Library.books_available(library)

    IO.puts("Book available by isbn")
    Library.book_available_by_isbn(library, "9780201616224")

    Library.book_available_by_isbn(library, "4444")

    IO.puts("Delete book")
    library = Library.delete_book(library, users, book2)
    IO.puts(length(library))
    library = Library.delete_book(library, users, book3)
    IO.puts(length(library))
    Library.list_books_io(library)

    IO.puts("Search_books")
    Library.search_books(library, "Dave")
  end
end

Library.run()
