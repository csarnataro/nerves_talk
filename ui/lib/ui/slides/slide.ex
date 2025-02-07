defmodule Ui.Slides.Slide do
  use Ecto.Schema
  import Ecto.Changeset

  schema "slides" do
    field :order, :integer
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(slide, attrs) do
    slide
    |> cast(attrs, [:order, :content])
    |> validate_required([:order, :content])
  end
end
