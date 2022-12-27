# Layeredex

Library for generating template files for layer architecture

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `layeredex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:layeredex, "~> 0.1.0"}
  ]
end
```

```elixir
config :layeredex,
  prefix: "Sna",
  folder_name: "sna"
```

`mix create_files` or `mix create_files -h` for help

`mix create_consumer --p folder/path_to_event` or `mix create_consumer -h` for help

