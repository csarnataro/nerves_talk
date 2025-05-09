defmodule Ui.Slides do
  @moduledoc """
  The Slides context.
  """

  import Ecto.Query, warn: false
  alias Ui.Repo

  alias Ui.Slides.Slide

  @doc """
  Returns the list of slides.

  ## Examples

      iex> list_slides()
      [%Slide{}, ...]

  """
  def list_slides(lang \\ "it") do
    Repo.all(
      from(s in Slide,
        where: s.lang == ^lang,
        order_by: [asc: s.lang, asc: s.order]
      )
    )
    |> Enum.with_index()
    |> Enum.map(fn {slide, i} ->
      %Slide{
        id: slide.id,
        order: slide.order,
        lang: slide.lang,
        content: slide.content,
        slide_number: i
      }
    end)
  end

  @doc """
  Gets a single slide.

  Raises `Ecto.NoResultsError` if the Slide does not exist.

  ## Examples

      iex> get_slide!(123)
      %Slide{}

      iex> get_slide!(456)
      ** (Ecto.NoResultsError)

  """
  def get_slide!(id), do: Repo.get!(Slide, id)

  @doc """
  Creates a slide.

  ## Examples

      iex> create_slide(%{field: value})
      {:ok, %Slide{}}

      iex> create_slide(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_slide(attrs \\ %{}) do
    %Slide{}
    |> Slide.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a slide.

  ## Examples

      iex> update_slide(slide, %{field: new_value})
      {:ok, %Slide{}}

      iex> update_slide(slide, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_slide(%Slide{} = slide, attrs) do
    slide
    |> Slide.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a slide.

  ## Examples

      iex> delete_slide(slide)
      {:ok, %Slide{}}

      iex> delete_slide(slide)
      {:error, %Ecto.Changeset{}}

  """
  def delete_slide(%Slide{} = slide) do
    Repo.delete(slide)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking slide changes.

  ## Examples

      iex> change_slide(slide)
      %Ecto.Changeset{data: %Slide{}}

  """
  def change_slide(%Slide{} = slide, attrs \\ %{}) do
    Slide.changeset(slide, attrs)
  end

  defp get_order(path) do
    case Path.basename(path) |> Integer.parse() do
      :error -> 0
      {value, _} -> value
    end
  end

  defp get_index_and_content_from_file(filepath) do
    index = Path.basename(filepath) |> String.split(".") |> Enum.at(0)
    {:ok, content} = File.read(filepath)

    %{index: index, content: content}
  end

  def reset() do
    Repo.delete_all(Slide)
    populate()
  end

  def populate() do
    path = Application.app_dir(:ui, "priv/repo/migrations")
    Ecto.Migrator.run(Ui.Repo, path, :up, all: true)

    Enum.map(["en", "it"], fn lang ->
      files =
        Path.join([:code.priv_dir(:ui), "data", "slides"])
        |> Path.join(lang)
        |> Path.join("*.md")
        |> Path.wildcard()
        |> Enum.sort(&(get_order(&1) < get_order(&2)))
        |> Enum.map(&get_index_and_content_from_file/1)
        |> Enum.map(fn file ->
          %Slide{
            order: String.to_integer(file.index),
            content: file.content,
            lang: lang
          }
        end)

      Enum.reduce(files, 0, fn slide, acc ->
        Ui.Repo.insert!(slide)
        acc + 1
      end)
    end)
  end
end
