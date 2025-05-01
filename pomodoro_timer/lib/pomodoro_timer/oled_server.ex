defmodule PomodoroTimer.OledServer do
  alias PomodoroTimer.FontServer

  use GenServer

  @doc false
  def start_link([]) do
    IO.puts("Starting array server")
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.puts("Initializing array server")
    {:ok, ref} = PomodoroTimer.Display.start_link()
    {:ok, %{ref: ref}}
  end

  @impl true
  def handle_cast(:clear, state) do
    PomodoroTimer.Display.clear()
    {:noreply, state}
  end

  @impl true
  def handle_cast({:set, x, y}, state) do
    PomodoroTimer.Display.put_pixel(x, y)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:update, state) do
    PomodoroTimer.Display.display()
    {:noreply, state}
  end

  # ----------------------------

  def clear do
    GenServer.cast(__MODULE__, :clear)
  end

  def set(x, y) do
    GenServer.cast(__MODULE__, {:set, x, y})
  end

  def update do
    GenServer.cast(__MODULE__, :update)
  end

  def write(text, x \\ 0, y \\ 0) do
    put_pixel = fn x, y ->
      set(x, y)
    end

    font = FontServer.get()

    PomodoroTimer.Display.fill_rect(0, y, 128, 8)
    PomodoroTimer.Display.fill_rect(0, y, 128, 8, mode: :xor)
    PomodoroTimer.Display.display()
    
    Chisel.Renderer.draw_text(" " |> String.duplicate(String.length(text)), x, y, font, put_pixel)
    Chisel.Renderer.draw_text(text, x, y, font, put_pixel)
    update()
  end
end
