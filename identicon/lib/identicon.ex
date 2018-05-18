defmodule Identicon do
   # |> takes result of previous and puts it in as first argument
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    # iterate through the pixel Map
    # Each has a tuple of two values, start and stop
    # start and stop are tuples representing top left and bottom right coord.
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index }) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # Filters and returns only the values the make the condition true
    grid = Enum.filter grid, fn({code_number, _index}) ->
      rem(code_number, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  # Takes an image struct and returns and image struct
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3) # same as Enum.chunk(hex, 3)
      # & tells that a reference to a function is going to be passed (instead of calling the function)
      # define specifically which function, the one that takes one argument. (arity of 1)
      |> Enum.map(&mirror_row/1) # Map over existing list, do some function on it, gets return value, puts it into a new list which is then returned.
      |> List.flatten #Flattens array of arrays
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
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
