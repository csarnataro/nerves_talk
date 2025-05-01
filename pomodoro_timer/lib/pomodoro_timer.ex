defmodule PomodoroTimer do
  @moduledoc """
  Documentation for `PomodoroTimer`.
  """
  alias Circuits.GPIO

  @behaviour :gen_statem

  @name :pomodoro_timer

  # in seconds
  @initial_time 6
  # in seconds
  @short_break 2
  # in seconds
  @long_break 4

  @button_gpio 4

  # apparently this is needed for implementing gen_statem behaviour, not sure why
  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      restart: :permanent,
      shutdown: 5000,
      type: :worker
    }
  end

  defp write_oled(text, x \\ 0, y \\ 0) do
    PomodoroTimer.OledServer.write(text, x, y)
  end

  def start_link(_) do
    :gen_statem.start({:local, @name}, __MODULE__, %{time: @initial_time, round: 4}, [])
  end

  # :gen_statem behaviour's implementations
  @impl :gen_statem
  def terminate(reason, _state, _data) do
    write_oled("Terminating state machine")
    write_oled("#{reason}", 10, 14)
  end

  @impl :gen_statem
  def callback_mode, do: :state_functions

  @impl :gen_statem
  def init(data) do
    # write_oled("Starting app with count: #{Map.get(data, :time)}", 10, 4)

    {:ok, button_gpio} = GPIO.open(@button_gpio, :input, pull_mode: :pullup)
    GPIO.set_interrupts(button_gpio, :both)

    # adding gpio to state, otherwise it will be garbage collected
    data = data |> Map.put(:gpio, button_gpio)
    {:ok, :off, data, [{:next_event, :internal, :start_the_whole_thing}]}
  end

  def off(:internal, :start_the_whole_thing, data) do
    write_oled("INIT...")
    :keep_state_and_data
  end
  
  def off(:internal, :push_btn, data) do
    write_oled("OFF...")
    :keep_state_and_data
  end


  def off(:info, {:circuits_gpio, @button_gpio, _timestamp, 0}, data) do
    :keep_state_and_data
  end

  def off(:info, {:circuits_gpio, @button_gpio, _timestamp, 1}, data) do
    {:next_state, :working, data, [{:next_event, :internal, :push_btn}]}
  end

  def working(:internal, :push_btn, data) do
    write_oled("WORKING HARD...", 10, 50)
    :keep_state_and_data
  end
  
  def working(:info, {:circuits_gpio, @button_gpio, _timestamp, 1}, data) do
    write_oled("RESTING... ", 10, 50)
    {:next_state, :off, data, [{:next_event, :internal, :push_btn}]}
  end
  
  def working(:info, {:circuits_gpio, @button_gpio, _timestamp, 0}, data) do
    :keep_state_and_data # {:next_state, :off, data, [{:next_event, :internal, :push_btn}]}
  end
end
