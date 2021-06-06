# Mmonitor

# Follow instructions to setup elixir env
https://elixir-lang.org/install.html#gnulinux

# To setup deps
mix local.hex --force
mix local.rebar --force
mix deps.get

# To build
MIX_ENV=prod mix release
# To start your system
    _build/prod/rel/mmonitor/bin/mmonitor start

Once the release is running:

    # To connect to it remotely
    _build/prod/rel/mmonitor/bin/mmonitor remote

    # To stop it gracefully (you may also send SIGINT/SIGTERM)
    _build/prod/rel/mmonitor/bin/mmonitor stop
