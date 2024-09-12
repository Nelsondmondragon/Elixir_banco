defmodule InventoryManager do
  defstruct products: [
              %{id: 1, name: "Laptop", price: 1000.0, stock: 10},
              %{id: 2, name: "Iphone", price: 100.0, stock: 20}
            ],
            shopping_cart: []

  def add_product(inventory, name, price, stock) do
    products = inventory.products
    id = length(products) + 1

    product = %{
      id: id,
      name: name,
      price: String.to_float(price),
      stock: String.to_integer(stock)
    }

    %InventoryManager{products: products ++ [product], shopping_cart: inventory.shopping_cart}
  end

  def list_products(inventory) do
    Enum.each(inventory.products, fn product ->
      IO.puts("#{product.id}. #{product.name}. #{product.price}. #{product.stock}.")
    end)
  end

  def increase_stock(inventory, id, quantity) do
    products =
      Enum.map(inventory.products, fn product ->
        if id == product.id do
          %{product | stock: product.stock + quantity}
        else
          product
        end
      end)

    %InventoryManager{products: products, shopping_cart: inventory.shopping_cart}
  end

  def sell_product(inventory, id, quantity) do
    {updated_products, updated_cart} =
      Enum.reduce(inventory.products, {[], inventory.shopping_cart}, fn product,
                                                                        {acc_products, acc_cart} ->
        if product.id == id do
          if product.stock >= quantity do
            updated_product = %{product | stock: product.stock - quantity}
            new_cart_item = {product.id, quantity}
            {acc_products ++ [updated_product], [new_cart_item | acc_cart]}
          else
            IO.puts("Cantidad superior al inventario")
            {acc_products ++ [product], acc_cart}
          end
        else
          {acc_products ++ [product], acc_cart}
        end
      end)

    %InventoryManager{
      products: updated_products,
      shopping_cart: updated_cart
    }
  end

  def view_cart(inventory) do
    Enum.each(inventory.shopping_cart, fn {id, quantity} ->
      product = Enum.find(inventory.products, fn prod -> prod.id == id end)

      if product do
        item_total = product.price * quantity

        IO.puts(
          "#{product.id}. #{product.name} - Cantidad: #{quantity}, Precio unitario: $#{product.price}, Total: $#{item_total}"
        )
      end
    end)
  end

  def checkout(inventory, cart) do
    total_price =
      Enum.reduce(cart, 0.0, fn {id, quantity}, acc ->
        product = Enum.find(inventory.products, fn prod -> prod.id == id end)

        if product do
          acc + product.price * quantity
        else
          acc
        end
      end)

    IO.puts("Total a pagar: $#{total_price}")
    %InventoryManager{inventory | shopping_cart: []}
  end

  def run do
    inventory = %InventoryManager{}
    # Start the main loop
    loop(inventory)
  end

  # Private function for the main loop
  # Parameters:
  #   task_manager: The current TaskManager struct
  defp loop(inventory) do
    # Display the menu
    IO.puts("""
    Gestor de Inventarios
    1. Agregar Producto
    2. Listar Productos
    3. Aumentar el stock
    4. Vender Producto
    5. Generar carrito de compras
    6. Generar venta
    7. Salir
    """)

    # Get user input
    IO.write("Seleccione una opción: ")
    option = String.trim(IO.gets(""))
    option = String.to_integer(option)

    # Process the user's choice
    if option == 1 do
      IO.write("Ingrese el nombre del producto: ")
      name = String.trim(IO.gets(""))
      IO.write("Ingrese el precio del producto: ")
      price = String.trim(IO.gets(""))
      IO.write("Ingrese el stock del producto: ")
      stock = String.trim(IO.gets(""))

      inventory = add_product(inventory, name, price, stock)
      loop(inventory)
    else
      if option == 2 do
        list_products(inventory)
        loop(inventory)
      else
        if option == 3 do
          IO.write("Ingrese el ID del producto: ")
          id = String.trim(IO.gets(""))
          id = String.to_integer(id)
          IO.write("Ingrese la cantidad que desea aumentar del producto: ")
          stock = String.trim(IO.gets(""))
          stock = String.to_integer(stock)
          inventory = increase_stock(inventory, id, stock)
          loop(inventory)
        else
          if option == 4 do
            IO.write("Ingrese el ID del producto: ")
            id = String.trim(IO.gets(""))
            id = String.to_integer(id)
            IO.write("Ingrese la cantidad que desea vender del producto: ")
            quantity = String.trim(IO.gets(""))
            quantity = String.to_integer(quantity)

            inventory = sell_product(inventory, id, quantity)
            loop(inventory)
          else
            if option == 5 do
              view_cart(inventory)
              loop(inventory)
            else
              if option == 6 do
                inventory = checkout(inventory, inventory.shopping_cart)
                loop(inventory)
              else
                if option == 7 do
                  IO.puts("¡Adiós!")
                else
                  IO.puts("Opción no válida.")
                  loop(inventory)
                end
              end
            end
          end
        end
      end
    end
  end
end

InventoryManager.run()
