# Configuration for the host (no LEDs to blink)
import Config

config :blinky,
  indicators: %{
    default: %{}
  }


config :circuits_sim,
  config: [
    {CircuitsSim.Device.GPIOButton, gpio_spec: "GPIO21"}
  ]
