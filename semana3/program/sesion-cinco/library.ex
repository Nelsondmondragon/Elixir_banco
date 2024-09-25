defmodule CryptoBank.Wallet do
  @doc """
  Creates a new wallet with initial balances.

  Returns: Map representing the wallet with keys :btc, :eth, and :usd
  """
  def new do
    %{
      btc: Decimal.new("0"),
      eth: Decimal.new("0"),
      usd: Decimal.new("1000")
    }
  end

  @doc """
  Adds funds to a wallet.

  Parameters:
  - wallet: Map representing the wallet
  - amount: Number or String, amount to add
  - currency: Atom, currency to add (:btc, :eth, or :usd)

  Returns: Updated wallet map
  """
  def add_funds(wallet, amount, currency) do
    # This function updates the wallet by adding funds to the specified currency
    # 1. Map.update! modifies the wallet map in-place
    # 2. It targets the key specified by the 'currency' parameter
    # 3. The anonymous function &Decimal.add/2 is applied to the current balance
    # 4. Decimal.new("#{amount}") converts the amount to a Decimal
    # 5. The result is a new wallet with the updated balance for the given currency
    Map.update!(wallet, currency, &Decimal.add(&1, Decimal.new("#{amount}")))
  end

  @doc """
  Removes funds from a wallet.

  Parameters:
  - wallet: Map representing the wallet
  - amount: Number or String, amount to remove
  - currency: Atom, currency to remove (:btc, :eth, or :usd)

  Returns:
  - {:ok, updated_wallet} on success
  - {:error, reason} if insufficient funds
  """
  def remove_funds(wallet, amount, currency) do
    # This line compares the wallet balance for the given currency with the amount to remove
    # Decimal.cmp returns :lt if the wallet balance is less than the amount
    # It returns :eq if they're equal, or :gt if the wallet balance is greater
    case Decimal.cmp(wallet[currency], Decimal.new("#{amount}")) do
      :lt -> {:error, "Insufficient funds"}
      _ -> {:ok, Map.update!(wallet, currency, &Decimal.sub(&1, Decimal.new("#{amount}")))}
    end
  end
end

defmodule CryptoBank.Transaction do
  @doc """
  Executes a transaction between two users.

  Parameters:
  - from_user: User struct of the sender
  - to_user: User struct of the recipient
  - amount: Number or String, amount to transfer
  - currency: Atom, currency of the transaction (:btc, :eth, or :usd)

  Returns:
  - {:ok, updated_from_user, updated_to_user} on success
  - {:error, reason} on failure
  """
  def execute(from_user, to_user, amount, currency) do
    with {:ok, from_wallet} <- Wallet.remove_funds(from_user.wallet, amount, currency),
         {:ok, to_wallet} <- {:ok, Wallet.add_funds(to_user.wallet, amount, currency)} do
      {:ok,
       %{from_user | wallet: from_wallet},
       %{to_user | wallet: to_wallet}}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end

defmodule CryptoBank.Product do
  @doc """
  Creates a new product.

  Parameters:
  - name: String, name of the product
  - price: Number or String, price of the product
  - currency: Atom, currency of the price (:btc, :eth, or :usd)

  Returns: Map representing the product
  """
  def new(name, price, currency) do
    %{
      name: name,
      price: Decimal.new("#{price}"),
      currency: currency
    }
  end
end
