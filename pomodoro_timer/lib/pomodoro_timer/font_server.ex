defmodule PomodoroTimer.FontServer do

    use GenServer

    @doc false
    def start_link(_) do
      IO.puts("Starting font server")
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    @impl true
    def init(_) do

      IO.puts("Initializing font server")
      path = Application.app_dir(:pomodoro_timer, "priv/fonts")
      Chisel.Font.load(Path.join(path, "clR6x12.bdf"))

      # Chisel.Font.load("/etc/simple.bdf")
    end

    @impl true
    def handle_call(:get, _from, font) do
      {:reply, font, font}
    end

    def get do
      GenServer.call(__MODULE__, :get, 10_000)
    end
  end
