defmodule CryptoBank.User do
  alias CryptoBank.Wallet

  @doc """
  Creates a new user.

  Parameters:
  - name: String, name of the user

  Returns: Map representing the user with keys :name, :wallet, and :purchased_products
  """
  def new(name) do
    %{
      name: name,
      wallet: Wallet.new(),
      purchased_products: []
    }
  end

  @doc """
  Allows a user to buy a product.

  Parameters:
  - user: Map representing the user
  - product: Map representing the product to buy

  Returns:
  - {:ok, updated_user} on successful purchase
  - {:error, reason} if purchase fails (e.g., insufficient funds)
  """
  def buy_product(user, product) do
    case Wallet.remove_funds(user.wallet, product.price, product.currency) do
      {:ok, updated_wallet} ->
        {:ok, %{user |
          wallet: updated_wallet,
          purchased_products: [product | user.purchased_products]
        }}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Lists all products purchased by a user.

  Parameters:
  - user: Map representing the user

  Returns: List of product maps
  """
  def list_purchased_products(user) do
    user.purchased_products
  end
end

# Command examples to interact with the CryptoBank program:

# 1. Start the CryptoBank application
# iex> state = CryptoBank.start()

# 2. Create users
# iex> {:ok, _, state} = CryptoBank.create_user(state, "Alice")
# iex> {:ok, _, state} = CryptoBank.create_user(state, "Bob")
# iex> {:ok, _, state} = CryptoBank.create_user(state, "Charlie")
# iex> {:ok, _, state} = CryptoBank.create_user(state, "Diana")

# 3. Get a user
# iex> alice = CryptoBank.get_user(state, "Alice")

# 4. Perform transactions
# iex> {:ok, _, state} = CryptoBank.transact(state, "Alice", "Bob", 50, :usd)
# iex> {:ok, _, state} = CryptoBank.transact(state, "Charlie", "Diana", 150, :usd)
# iex> {:ok, _, state} = CryptoBank.transact(state, "Bob", "Charlie", 75, :usd)

# 5. Create products
# iex> {:ok, _, state} = CryptoBank.create_product(state, "Bitcoin Mining Rig", 5000, :usd)
# iex> {:ok, _, state} = CryptoBank.create_product(state, "Ethereum Mining Rig", 3000, :usd)
# iex> {:ok, _, state} = CryptoBank.create_product(state, "Crypto Trading Course", 500, :usd)
# iex> {:ok, _, state} = CryptoBank.create_product(state, "Hardware Wallet", 100, :usd)
# iex> {:ok, _, state} = CryptoBank.create_product(state, "Blockchain Book", 50, :usd)

# 6. List all products
# iex> products = CryptoBank.list_products(state)

# 7. Buy products
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Alice", "Bitcoin Mining Rig")
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Bob", "Ethereum Mining Rig")
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Charlie", "Crypto Trading Course")
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Diana", "Hardware Wallet")
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Alice", "Blockchain Book")

# 8. List purchased products for users
# iex> alice = CryptoBank.get_user(state, "Alice")
# iex> alice_products = CryptoBank.User.list_purchased_products(alice)
# iex> bob = CryptoBank.get_user(state, "Bob")
# iex> bob_products = CryptoBank.User.list_purchased_products(bob)
# iex> charlie = CryptoBank.get_user(state, "Charlie")
# iex> charlie_products = CryptoBank.User.list_purchased_products(charlie)
# iex> diana = CryptoBank.get_user(state, "Diana")
# iex> diana_products = CryptoBank.User.list_purchased_products(diana)

# 9. Check users' wallet balances
# iex> alice.wallet
# iex> bob.wallet
# iex> charlie.wallet
# iex> diana.wallet

# 10. Attempt a transaction with insufficient funds
# iex> {:error, reason, state} = CryptoBank.transact(state, "Alice", "Bob", 10000, :usd)

# 11. Attempt to buy a product with insufficient funds
# iex> {:error, reason, state} = CryptoBank.buy_product(state, "Charlie", "Bitcoin Mining Rig")

# 12. Add funds to a user's wallet (assuming this function exists in CryptoBank)
# iex> {:ok, _, state} = CryptoBank.add_funds(state, "Charlie", 5000, :usd)

# 13. Try buying the product again after adding funds
# iex> {:ok, _, state} = CryptoBank.buy_product(state, "Charlie", "Bitcoin Mining Rig")

# 14. Perform a currency conversion (assuming this function exists in CryptoBank)
# iex> {:ok, _, state} = CryptoBank.convert_currency(state, "Diana", 50, :usd, :btc)

# 15. Check Diana's wallet after conversion
# iex> diana = CryptoBank.get_user(state, "Diana")
# iex> diana.wallet

# 16. List all users
# iex> users = Map.keys(state.users)

# 17. Get the total value of products purchased by each user
# iex> alice_total = Enum.reduce(alice_products, Decimal.new("0"), fn p, acc -> Decimal.add(acc, p.price) end)
# iex> bob_total = Enum.reduce(bob_products, Decimal.new("0"), fn p, acc -> Decimal.add(acc, p.price) end)
# iex> charlie_total = Enum.reduce(charlie_products, Decimal.new("0"), fn p, acc -> Decimal.add(acc, p.price) end)
# iex> diana_total = Enum.reduce(diana_products, Decimal.new("0"), fn p, acc -> Decimal.add(acc, p.price) end)

# 18. Find the user with the most valuable purchases
# iex> max_value_user = Enum.max_by([
# ...>   {alice, alice_total},
# ...>   {bob, bob_total},
# ...>   {charlie, charlie_total},
# ...>   {diana, diana_total}
# ...> ], fn {_, total} -> total end)

# Note: Some of these commands (like add_funds, convert_currency) assume additional
# functions that are not currently implemented in the provided CryptoBank module.
# You would need to add these functions to use them.
