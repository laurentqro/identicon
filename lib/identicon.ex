defmodule Identicon do
  @moduledoc """
  Generates an identicon based on a username.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_hex_value, index}) ->
      horizontal = rem(index, 5) * 50
      vertical =   div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filter odd squares.

  ## Examples
      iex> image = %Identicon.Image{grid: [{114, 0}, {179, 1}]}
      iex> image = Identicon.filter_odd_squares(image)
      iex> image.grid
      [{114, 0}]
  """

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({hex_value, _index}) ->
      rem(hex_value, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
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
