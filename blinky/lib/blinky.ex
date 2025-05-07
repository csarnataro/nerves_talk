defmodule Blinky do
  use GenServer

  require Logger
  alias Circuits.GPIO
  alias Pigpiox.Pwm

  @text "HELLO WORLD"

  # dit duration in ms, e.g. 100 ms
  @dit 100
  @led_gpio "GPIO21"
  @buzzer_gpio 12
  @buzzer_freq 400

  @alphabet %{
    "A" => ".-",
    "B" => "-...",
    "C" => "-.-.",
    "D" => "-..",
    "E" => ".",
    "F" => "..-.",
    "G" => "--.",
    "H" => "....",
    "I" => "..",
    "J" => ".---",
    "K" => "-.-",
    "L" => ".-..",
    "M" => "--",
    "N" => "-.",
    "O" => "---",
    "P" => ".--.",
    "Q" => "--.-",
    "R" => ".-.",
    "S" => "...",
    "T" => "-",
    "U" => "..-",
    "V" => "...-",
    "W" => ".--",
    "X" => "-..-",
    "Y" => "-.--",
    "Z" => "--..",
    " " => " "
  }

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_state) do
    {:ok, gpio} = GPIO.open(@led_gpio, :output)

    morse_encoded_letters =
      @text
      |> String.graphemes()
      |> Enum.map(fn g -> @alphabet[g] end)

    initial_state = %{
      morse_encoded_letters: morse_encoded_letters,
      # apparently it must be kept in the state othewise it will be
      # garbage collected
      gpio: gpio,
    }

    schedule_letter(initial_state)
    {:ok, initial_state}
  end

  def handle_info(:dit_up, state) do
    %{gpio: gpio} = state
    GPIO.write(gpio, 1)
    Pwm.hardware_pwm(@buzzer_gpio, @buzzer_freq, 500_000)
    {:noreply, state}
  end

  def handle_info(:dit_down, state) do
    %{gpio: gpio} = state
    GPIO.write(gpio, 0)
    Pwm.hardware_pwm(@buzzer_gpio, 0, 0)
    {:noreply, state}
  end

  def handle_info(:next_letter, state) do
    %{morse_encoded_letters: morse_encoded_letters} = state
    [_letter | rest] = morse_encoded_letters
    new_state = %{state | morse_encoded_letters: rest}
    schedule_letter(new_state)
    {:noreply, new_state}
  end

  def handle_info(:restart, state) do
    morse_encoded_letters =
      @text
      |> String.graphemes()
      |> Enum.map(fn g -> @alphabet[g] end)

    initial_state = %{state | morse_encoded_letters: morse_encoded_letters}

    schedule_letter(initial_state)
    {:noreply, initial_state}
  end

  defp schedule_letter(%{morse_encoded_letters: []}) do
    Process.send_after(self(), :restart, 3 * @dit)
  end

  defp schedule_letter(state) do
    %{morse_encoded_letters: morse_encoded_letters} = state
    [letter | _rest] = morse_encoded_letters

    times =
      letter
      |> String.graphemes()
      |> Enum.reduce(0, fn g, acc ->
        case g do
          "." ->
            Process.send_after(self(), :dit_up, acc * @dit)
            Process.send_after(self(), :dit_down, (acc + 1) * @dit)
            acc + 2

          "-" ->
            Process.send_after(self(), :dit_up, acc * @dit)
            Process.send_after(self(), :dit_down, (acc + 3) * @dit)
            acc + 4

          " " ->
            acc + 3
        end
      end)

    Process.send_after(self(), :next_letter, (times + 1) * @dit)
  end
end
