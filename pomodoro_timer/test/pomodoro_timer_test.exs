defmodule PomodoroTimerTest do
  use ExUnit.Case
  doctest PomodoroTimer

  test "greets the world" do
    assert PomodoroTimer.hello() == :world
  end
end
