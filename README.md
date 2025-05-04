# Demos for my "Introduction to Nerves" talk

This repo contains 4 demos I presented at my "Introduction to Nerves" talk
at the Elixir Language Milan Meetup on May 20th 2005.

1. **Blinky**
    A  n



# Livebook + Liveview Nerves project 

Slides and code for the talk held at Milan Elixir Meetup in May 2025.



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

## `sudo` with asdf

sudo -E env "PATH=$PATH" MIX_TARGET=rpi0 mix burn

sudo -E env "PATH=$PATH" MIX_TARGET=rpi0 mix do deps.get, compile, firmware && ./upload.sh nerves.local


## Reference

* https://hexdocs.pm/nerves/getting-started.html
