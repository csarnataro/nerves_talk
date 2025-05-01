defmodule PomodoroTimer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Children for all targets
        # Starts a worker by calling: PomodoroTimer.Worker.start_link(arg)
        # {PomodoroTimer.Worker, arg},
      ] ++ children(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :one_for_all, name: PomodoroTimer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children(:host) do
    [
      # Children that only run on the host during development or test.
      # In general, prefer using `config/host.exs` for differences.
      #
      # Starts a worker by calling: Host.Worker.start_link(arg)
      # {Host.Worker, arg},
    ]
  end

  defp children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Target.Worker.start_link(arg)
      # {Target.Worker, arg},
      {PomodoroTimer.FontServer, []},
      {PomodoroTimer.OledServer, []},
      {PomodoroTimer, []}
    ]
  end

  def target() do
    Application.get_env(:pomodoro_timer, :target)
  end
end
