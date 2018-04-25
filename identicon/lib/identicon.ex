defmodule Identicon do
   # |> takes result of previous and puts it in as first argument
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  # Takes an image struct and returns and image struct
  def build_grid(%Identicon.Image{hex: hex}) do
    hex
    |> Enum.chunk(3) # same as Enum.chunk(hex, 3)
    # & tells that a reference to a function is going to be passed (instead of calling the function)
    # define specifically which function, the one that takes one argument. (arity of 1)
    |> Enum.map(&mirror_row/1) # Map over existing list, do some function on it, gets return value, puts it into a new list which is then returned.
  end

  # takes a single row and returns a longer row that has been mirrored.
  # in: [145, 46, 200]
  # out: [145, 46, 200, 46, 145]
  def mirror_row(row) do
    [first, second | _tail] = row

    # copies and produces a brand new row. immutable data in elixir
    row ++ [second, first]
  end

  # Takes an image struct and returns an image struct with defined r g b values
  # which are chosen from the first three numbers of the hex list
  # The color property is a tuple
  # The hex property is a list
  # def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image)
  def pick_color(image) do
    # %Identicon.Image{hex: hex_list} = image
    # [r, g, b | _tail] = hex_list

    %Identicon.Image{hex: [r, g, b | _tail]} = image

    %Identicon.Image{image | color: {r, g, b}}
  end



  # Takes a string and returns an Image struct which has
  # a hex property. Here, the hex property that is returned is a list of numbers that is
  # created by the crypto.hash.
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

end
