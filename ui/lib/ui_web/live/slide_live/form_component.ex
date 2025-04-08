defmodule UiWeb.SlideLive.FormComponent do
  use UiWeb, :live_component

  alias Ui.Slides

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage slide records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="slide-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:order]} type="number" label="Order" />
        <.input type="textarea" class="font-mono" field={@form[:content]} label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Slide</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{slide: slide} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Slides.change_slide(slide))
     end)}
  end

  @impl true
  def handle_event("validate", %{"slide" => slide_params}, socket) do
    changeset = Slides.change_slide(socket.assigns.slide, slide_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"slide" => slide_params}, socket) do
    save_slide(socket, socket.assigns.action, slide_params)
  end

  defp save_slide(socket, :edit, slide_params) do
    case Slides.update_slide(socket.assigns.slide, slide_params) do
      {:ok, slide} ->
        notify_parent({:saved, slide})

        {:noreply,
         socket
         |> put_flash(:info, "Slide updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_slide(socket, :new, slide_params) do
    case Slides.create_slide(slide_params) do
      {:ok, slide} ->
        notify_parent({:saved, slide})

        {:noreply,
         socket
         |> put_flash(:info, "Slide created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
