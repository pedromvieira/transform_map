# TransformMap

Transform Elixir Deeply Nested Maps into flat maps or 2 dimensional array. Export any map to CSV, XLSX or JSON. [https://hex.pm/packages/transform_map](https://hex.pm/packages/transform_map).

## Installation

1. Add `transform_map` to your list of dependencies in `mix.exs`:

```elixir

def deps do
  [
    {:transform_map, ">= 1.0.0"}
  ]
end

```

## Usage

```elixir

  iex> TransformMap.multiple_shrink(map, "|", true, true)

  iex> TransformMap.multiple_expand(shrink_map, "|", true)

  iex> TransformMap.multiple_to_array(map, "|", true, true)

  iex> TransformMap.multiple_keys(shrink_map, true)

  iex> TransformMap.multiple_to_array(map, "|", true, true) |> TransformMap.Export.to_csv("test.csv", true, "temp/report")

  iex> TransformMap.multiple_to_array(map, "|", true, true) |> TransformMap.Export.to_xlsx("test.xlsx", true, "temp/report")

  iex> map |> TransformMap.Export.to_json("test.json", true, "temp/report")

  iex> "temp/report/test.csv" |> TransformMap.Export.to_gzip()

```

## News

- **2018/08/12**
  - Choose export directory.
- **2018/04/28**
  - Default delimiter "."
  - Fix first level list of maps
- **2018/04/28**
  - Decimal validation
- **2018/04/27**
  - Initial version


## Documentation

Docs can be found at [https://hexdocs.pm/transform_map](https://hexdocs.pm/transform_map).

## License

    Copyright © 2018 Pedro Vieira <pedro@vieira.net>

    This work is free. You can redistribute it and/or modify it under the
    terms of the MIT License. See the LICENSE file for more details.
