# Groupstrip

GroupStrip is a OS-agnostic batch management platform inspired by [MKVOptimizer](https://www.videohelp.com/software/MKV-Optimizer). It runs in a dockerized container with a locally accessible Web GUI, much like [Sonarr](https://github.com/Sonarr/Sonarr) (has queue, can have different directories formatting differently, asynchronous processes), and integrates with [MKVToolNix](https://mkvtoolnix.download) to provide easy batch management for baked-in tracks on your video files.

## Requirements

Elixir 1.12/OTP 24
Docker

## Installation 

1. Install asdf with `brew install asdf`
1. Install plugin for elixir with `asdf add plugin elixir`
1. Install needed Elixir version with `asdf install elixir 1.12.1-otp-24`
1. Enable necessary Elixir version with `asdf shell elixir 1.12.1-otp-24`
  - The `.tool-versions` file will automatically enable this elixir version when you cd into the directory from now on (requires asdf to be installed).
1. Hex is the Elixir package manager, but it is not installed automatically. You can install Hex with `mix local.hex`.
1. Check that the correct versions are enabled with `elixir -v`.

## Development

1. Install Elixir and Node dependencies in root with `mix setup`, which is a directive defined in the aliases in `mix.exs`.
1. Start Phoenix endpoint from root with `mix phx.server`
1. Run the Groupstrip instide IEx (Interactive Elixir, basically, `rails console`) with `iex -S mix phx.server`
 
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## iEX

Run:
```elixir
recompile()
```

in iex to force compilation from inside the shell.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
