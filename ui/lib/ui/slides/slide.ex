defmodule Ui.Slides.Slide do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slides" do
    field :order, :integer
    field :content, :string
    field :lang, :string
    field :slide_number, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(slide, attrs) do
    slide
    |> cast(attrs, [:lang, :order, :content])
    |> validate_required([:lang, :order, :content])
  end
end
