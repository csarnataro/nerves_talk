# Livebook + Liveview Nerves project 

### Random notes (still in progress)

MIX_TARGET=rpi4 sudo -E mix deps.get

MIX_TARGET=rpi4 sudo -E mix firmware

MIX_TARGET=rpi4 sudo -E mix firmware.burn

  
http://nerves.local:4000/slides


--- 

Temporary solution to launch Ecto migration on the device:

1. ssh into device with `ssh nerves.local`

2. launch
    ```elixir
    path = Application.app_dir(:ui, "priv/repo/migrations")
    Ecto.Migrator.run(Ui.Repo, path, :up, all: true)
    ```