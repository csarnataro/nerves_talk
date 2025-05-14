defmodule PomodoroTimer do
  @moduledoc """
  Documentation for `PomodoroTimer`.
  """
  alias Circuits.GPIO

  @behaviour :gen_statem

  @name :pomodoro_timer

  # 0 based
  @rounds_number 3
  # in seconds
  @initial_time 6
  # in seconds
  @short_break 2
  # in seconds
  @long_break 4

  @button_gpio 4

  @servo_gpio 12
  @servo_max 2350
  @servo_min 520

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

  def headline(text) do
    PomodoroTimer.OledServer.write(text, 2, 0)
  end

  def write_line(text, line) when line > 0 and line < 4 do
    PomodoroTimer.OledServer.write(text, 2, line * 16)
  end

  def write_line(text, _line) do
    write_line(text, 3)
  end

  def clear_screen() do
    PomodoroTimer.OledServer.clear()
  end

  def start_link(_) do
    :gen_statem.start(
      {:local, @name},
      __MODULE__,
      %{time: @initial_time, round: @rounds_number, break_duration: @short_break},
      []
    )
  end

  # :gen_statem behaviour's implementations
  @impl :gen_statem
  def terminate(reason, _state, _data) do
    headline("Terminating")
    write_line("#{reason}", 1)
  end

  @impl :gen_statem
  def callback_mode, do: [:state_functions, :state_enter]

  @impl :gen_statem
  def init(data) do
    {:ok, button_gpio} = GPIO.open(@button_gpio, :input, pull_mode: :pullup)
    GPIO.set_interrupts(button_gpio, :both)

    # adding gpio to state, otherwise it will be garbage collected
    data = data |> Map.put(:gpio, button_gpio)

    move_arrow(:idle)
    {:ok, :idle, data, [{:next_event, :internal, :start_the_whole_thing}]}
  end

  def idle(:enter, _, _) do
    move_arrow(:idle)
    :keep_state_and_data
  end

  def idle(:internal, :start_the_whole_thing, _data) do
    headline("READY...")
    :keep_state_and_data
  end

  def idle(:internal, :push_btn, _data) do
    clear_screen()
    headline("OFF")
    :keep_state_and_data
  end

  def idle(:info, {:circuits_gpio, @button_gpio, _timestamp, 0}, _data) do
    :keep_state_and_data
  end

  def idle(:info, {:circuits_gpio, @button_gpio, _timestamp, 1}, data) do
    {:next_state, :working, data, [{:next_event, :internal, :push_btn}]}
  end

  def working(:enter, _, _) do
    move_arrow(:working)
    :keep_state_and_data
  end

  def working(:internal, :push_btn, data) do
    headline("WORKING, R. #{1 + @rounds_number - data.round}")

    actions = [
      {:timeout, 1000, :one_second}
    ]

    data =
      data
      |> Map.update(:time, 0, fn _ -> @initial_time end)

    # |> Map.update(:round, 0, fn prev -> prev - 1 end)

    {:keep_state, data, actions}
  end

  def working(:internal, :pause_is_over, data) do
    clear_screen()
    headline("BACK TO WORK, R: #{1 + @rounds_number - data.round}")

    actions = [
      {:timeout, 1000, :one_second}
    ]

    data =
      data
      |> Map.update(:time, 0, fn _ -> @initial_time end)

    {:keep_state, data, actions}
  end

  def working(:timeout, :one_second, %{:time => 0, :round => 0} = data) do
    data = %{data | time: @initial_time, round: @rounds_number, break_duration: @long_break}

    actions = [{:next_event, :internal, :start_break}]
    {:next_state, :pause, data, actions}
  end

  def working(:timeout, :one_second, %{:time => 0} = data) do
    data = data |> Map.update(:break_duration, 0, fn _ -> @short_break end)
    data = data |> Map.update(:round, 0, fn prev -> prev - 1 end)
    actions = [{:next_event, :internal, :start_break}]
    {:next_state, :pause, data, actions}
  end

  def working(:timeout, :one_second, data) do
    printable_time = 1 + @initial_time - (data |> Map.get(:time))
    write_line("Seconds: #{printable_time}", 1)
    # write_line("Round: #{printable_round}", 2)
    data = Map.update(data, :time, 0, fn prev -> prev - 1 end)
    actions = [{:timeout, 1000, :one_second}]
    {:keep_state, data, actions}
  end

  def working(:info, {:circuits_gpio, @button_gpio, _timestamp, 1}, data) do
    data = %{data | time: @initial_time, round: @rounds_number, break_duration: @long_break}
    {:next_state, :idle, data, [{:next_event, :internal, :push_btn}]}
  end

  def working(:info, {:circuits_gpio, @button_gpio, _timestamp, 0}, _data) do
    # {:next_state, :idle, data, [{:next_event, :internal, :push_btn}]}
    :keep_state_and_data
  end

  def idle(:enter, _, _) do
    move_arrow(:short_break)
    :keep_state_and_data
  end

  def pause(:enter, _, %{:break_duration => @short_break}) do
    move_arrow(:short_break)
    :keep_state_and_data
  end

  def pause(:enter, _, %{:break_duration => @long_break}) do
    move_arrow(:long_break)
    :keep_state_and_data
  end

  def pause(:internal, :start_break, data) do
    clear_screen()
    headline("PAUSE #{data.break_duration} s.")
    # :keep_state_and_data
    {:keep_state, data, [{:timeout, 1000, :one_second}]}
  end

  def pause(:timeout, :one_second, %{:break_duration => 0} = data) do
    actions = [{:next_event, :internal, :pause_is_over}]
    {:next_state, :working, data, actions}
  end

  def pause(:timeout, :one_second, data) do
    write_line("Pause -#{data.break_duration}", 1)
    data = data |> Map.update(:break_duration, 0, fn prev -> prev - 1 end)
    actions = [{:timeout, 1000, :one_second}]
    {:keep_state, data, actions}
  end

  def pause(:info, {:circuits_gpio, @button_gpio, _timestamp, 0}, _data) do
    :keep_state_and_data
  end

  def pause(:info, {:circuits_gpio, @button_gpio, _timestamp, 1}, data) do
    data = %{data | time: @initial_time, round: @rounds_number, break_duration: @long_break}
    {:next_state, :idle, data, [{:next_event, :internal, :push_btn}]}
  end

  defp move_arrow(position) do
    position =
      case position do
        :idle -> 1
        :long_break -> 2
        :short_break -> 3
        :working -> 4
      end

    Pigpiox.Socket.command(
      :set_servo_pulsewidth,
      @servo_gpio,
      trunc(@servo_min + position * ((@servo_max - @servo_min) / 5))
    )
  end
end
