defmodule UiWeb.SlideLive.Index do
  use UiWeb, :live_view

  alias Ui.Slides
  alias Ui.Slides.Slide

  @impl true
  def mount(_params, _session, socket) do

    slides = Slides.list_slides()

    IO.inspect(slides)
    # slides2 =
    #   slides
    #   |> Enum.with_index()
    #   |> Enum.map(fn {s, i} -> %{:slide => s, :id => i} end)
    {:ok, stream(socket, :slides, slides)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Slide")
    |> assign(:slide, Slides.get_slide!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Slide")
    |> assign(:slide, %Slide{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Slides")
    |> assign(:slide, nil)
  end

  @impl true
  def handle_info({UiWeb.SlideLive.FormComponent, {:saved, slide}}, socket) do
    {:noreply, stream_insert(socket, :slides, slide)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    slide = Slides.get_slide!(id)
    {:ok, _} = Slides.delete_slide(slide)

    {:noreply, stream_delete(socket, :slides, slide)}
  end
end
