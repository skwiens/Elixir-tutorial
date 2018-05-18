defmodule Identicon.Image do
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end

# A struct is like a map with two additional features
   # It can be assigned default values
   # It has some additional compile time checking and properties

# Struct over a map:
  # A struct enforces that it will only have the properties defined in the module.
  # A normal map will let you defined any properties you want
