# PomodoroTimer

A digital Pomodoro Timer deployed on a Raspberry Pi 2.

**Warning**: the documentation for this demos is a work-in-progress and, as such, rather incomplete.
    If you need clarifications with any of the steps to build or run the demos, please [create an issue on GitHub](https://github.com/csarnataro/nerves_talk/issues).


The logic is implemented using the `:gen_statem` behaviour, where each state of the timer
can be either `idle` or `working` or `pause', with different events causing a transition
from one state to another.

The current state of the timer is shown either on a 0.96" OLED screen and through a servo 
motor with an arrow mounted on it.

## Schematics
_Coming soon_






## Notes

Upload firmware in just one command with:

```sh
export MIX_TARGET=rpi2 && sudo -E env "PATH=$PATH" mix do deps.get, compile, firmware && ./upload.sh nerves.local
```

*** 

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/supported-targets.html

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Elixir Slack #nerves channel: https://elixir-slack.community/
  * Elixir Discord #nerves channel: https://discord.gg/elixir
  * Source: https://github.com/nerves-project/nerves
