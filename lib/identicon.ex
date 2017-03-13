defmodule Identicon do
  @moduledoc """
  Generates an identicon based on a username.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
  Builds the identicon grid.

  ## Examples
      iex> image = %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
      iex> image = Identicon.build_grid(image)
      iex> image.grid
      [{114, 0}, {179, 1}, {2, 2}, {114, 3}, {179, 4}, {191, 5}, {41, 6},
       {122, 7}, {191, 8}, {41, 9}, {34, 10}, {138, 11}, {117, 12}, {34, 13},
       {138, 14}, {115, 15}, {1, 16}, {35, 17}, {115, 18}, {1, 19}, {239, 20},
       {239, 21}, {124, 22}, {239, 23}, {239, 24}]
  """

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [first, second]
  end

  @doc """
  Picks a color for the identicon.

  ## Examples
      iex> image = %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
      iex> Identicon.pick_color(image)
      %Identicon.Image{color: {114, 179, 2}, hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Converts a string into a unique sequence of characters.

  ## Examples
      iex> Identicon.hash_input("banana")
      %Identicon.Image{hex: [114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]}
  """

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
