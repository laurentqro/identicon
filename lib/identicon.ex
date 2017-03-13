defmodule Identicon do
  @moduledoc """
  Generates an identicon based on a username.
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc """
  Converts a string into a unique sequence of characters.

  ## Examples
      iex> hash = :crypto.hash(:md5, "banana")
      iex> :binary.bin_to_list(hash)
      [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]
  """

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
