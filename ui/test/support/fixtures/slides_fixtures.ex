defmodule Ui.SlidesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ui.Slides` context.
  """

  @doc """
  Generate a slide.
  """
  def slide_fixture(attrs \\ %{}) do
    {:ok, slide} =
      attrs
      |> Enum.into(%{
        content: "some content",
        order: 42
      })
      |> Ui.Slides.create_slide()

    slide
  end
end
