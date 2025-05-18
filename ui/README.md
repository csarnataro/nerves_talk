# Liveview slides 

Liveview/Phoenix app which serves the slides used in my talk "Introduction to Nerves"
at the Elixir Language Milan Meetup, on May 20th 2005.

**Warning**: the documentation for this demos is a work-in-progress and, as such, rather incomplete.
    If you need clarifications with any of the steps to build or run the demos, please [create an issue on GitHub](https://github.com/csarnataro/nerves_talk/issues).


You can launch the app locally on your PC or build the app and upload it on a Raspberry Pi.

Actually, this app is a depenency of `nerves_livebook` app available at [../nerves_livebook](../nerves_livebook/),
so if you want to upload it on a Raspberry Pi, you have to do it from within the `nerves_livebook` app.
But if you want to run the slides on your PC for development purposes, you can do it running:

```sh
MIX_TARGET=host mix deps.get && mix phx.server
```

For some reasons, depending on the target, sometime you need to launch some commands as `sudo`.

If you get some permission errors, try to launch the commands prefixed with `sudo -E`.

E.g.
```sh
MIX_TARGET=rpi4 sudo -E mix firmware.burn
```

## `sudo` with asdf
If you're using `asdf` can be useful to set the variable `PATH` for the sudo user, with command:

```sh
sudo -E env "PATH=$PATH" MIX_TARGET=rpi4 mix burn
sudo -E env "PATH=$PATH" MIX_TARGET=rpi4 mix do deps.get, compile, firmware && ./upload.sh nerves.local
```
