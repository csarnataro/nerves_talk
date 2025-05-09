defmodule UiWeb.SlidesController do
  use UiWeb, :controller

  alias Ui.Slides
  # alias Ui.Slides.Slide

  plug(:put_view, __MODULE__.View)

  @default_language "it"
  @available_languages ["it", "en"]

  def as_json(conn, params) do
    lang = get_language(params)

    slides =
      read_slides_from_db(lang)

    json(conn, %{slides: slides})
  end

  def reset_db(conn, _params) do
    Slides.reset()
    redirect(conn, to: ~p"/")
  end

  def from_files(conn, params) do
    lang = get_language(params)
    slides = read_slide_files(lang)

    conn
    |> put_layout(html: false)
    |> put_root_layout(html: {UiWeb.Layouts, :slides})
    |> render(:deck, slides: slides)
  end

  def home(conn, params) do
    lang = get_language(params)

    slides =
      read_slides_from_db(lang)
      |> Enum.map(& &1.content)
      |> Enum.join("\n\n---\n\n")

    conn
    |> put_layout(html: false)
    |> put_root_layout(html: {UiWeb.Layouts, :slides})
    |> render(:deck, slides: slides)
  end

  defp get_language(params) do
    %{"lang" => lang} = Map.merge(%{"lang" => @default_language}, params)

    if lang in @available_languages do
      lang
    else
      @default_language
    end
  end

  defp get_order(path) do
    case Path.basename(path) |> Integer.parse() do
      :error -> 0
      {value, _} -> value
    end
  end

  defp read_slides_from_db(lang) do
    try do
      Slides.list_slides(lang)
      |> Enum.map(&%{content: &1.content})
    rescue
      _e in Exqlite.Error ->
        Slides.populate()

        Slides.list_slides(lang)
        |> Enum.map(&%{content: &1.content})
    end
  end

  defp read_slide_files(lang) do
    Path.join([:code.priv_dir(:ui), "data", "slides"])
    |> Path.join(lang)
    |> Path.join("*.md")
    |> Path.wildcard()
    |> Enum.sort(&(get_order(&1) < get_order(&2)))
    |> Enum.map(&File.read!/1)
    |> Enum.join("\n\n---\n\n")
  end

  defmodule View do
    use UiWeb, :html

    def deck(assigns) do
      ~H"""
      {assigns.slides}
      """
    end
  end
end
