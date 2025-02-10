# Livebook + Liveview Nerves project 

Work in progress. There are still a few issues

1. Phoenix LiveView versions not fully compatible between Livebook and LiveView
   E.g. templates in the form `{@title}` do not work
2. Ecto migration not launched automatically at startup

### Random notes (still in progress)

MIX_TARGET=rpi4 sudo -E mix deps.get

MIX_TARGET=rpi4 sudo -E mix firmware

MIX_TARGET=rpi4 sudo -E mix firmware.burn


# Build
MIX_TARGET=rpi4 sudo -E mix do deps.get, firmware


http://nerves.local:4000/slides


--- 

Temporary solution to launch Ecto migration on the device:

1. ssh into device with `ssh nerves.local`

2. launch
    ```elixir
    path = Application.app_dir(:ui, "priv/repo/migrations")
    Ecto.Migrator.run(Ui.Repo, path, :up, all: true)
    ```