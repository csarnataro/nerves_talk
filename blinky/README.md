# Blinky

Inspired by the original "blinky" example available in the [Nerves examples repo](https://github.com/nerves-project/nerves_examples).

This version has been improved with an external LED (with its resistor) and a buzzer.

In this demo, instead of just blinking the LED indefinitely, the LED turns on and off
to show a Morse encoded message (see file [./lib/blinky.ex], line 8).

Unlike the original blinky example, the LED is controlled via the `circuits_gpio` library.

The buzzer is controlled via the `pigpiox` library, specifically via the `PWM` module.

***

[Raspberry Pi Zero](https://www.raspberrypi.com/products/raspberry-pi-zero)

## Hardware


## Description


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
