# Blinky

Inspired by the original "blinky" example available in the [Nerves examples repo](https://github.com/nerves-project/nerves_examples).

**Warning**: the documentation for this demo is a work-in-progress and, as such, rather incomplete.
If you need clarifications with any of the steps to build or run the demo, please [create an issue on GitHub](https://github.com/csarnataro/nerves_talk/issues).


This version has been improved with an external LED (with its resistor) and a buzzer.

In this demo, instead of just blinking the LED indefinitely, the LED turns on and off
to show a Morse encoded message (see file [./lib/blinky.ex], line 8).

Unlike the original blinky example, the LED is controlled via the `circuits_gpio` library.

The buzzer is controlled via the `pigpiox` library, specifically via the `PWM` module.

## How to build the firmware for a Raspberry Pi 0

```sh
sudo -E env "PATH=$PATH" MIX_TARGET=rpi4 mix do deps.get, compile, firmware.burn
```

Then upload the firmware on a SD card, plug it in your Raspberry and restart it. 

## Schematics
_Coming soon_


## How to Use the Code in this Repository

1. Specify your [target] with the `MIX_TARGET` environment variable
2. Get dependencies with `mix deps.get`
3. Create firmware with `mix firmware`
4. Burn firmware to an SD card with `mix firmware.burn`
5. Insert the SD card into your target board and power it on
6. After about 10-30 seconds, the configured LED(s) should start blinking its Morse message

```bash
export MIX_TARGET=rpi0
mix deps.get
mix firmware
mix firmware.burn
```

## Learn More

* Official docs: https://hexdocs.pm/nerves/getting-started.html
* Official website: https://nerves-project.org/
* Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
* Source: https://github.com/nerves-project/nerves

[target]: https://hexdocs.pm/nerves/targets.html
