defmodule UiWeb.SlidesController do
  use UiWeb, :controller

  plug(:put_view, __MODULE__.View)

  def home(conn, _params) do
    slides = read_slide_files()

    conn
    |> put_layout(html: false)
    |> put_root_layout(html: {UiWeb.Layouts, :slides})
    |> render(:deck, slides: slides)
  end

  defp get_order(path) do
    case Path.basename(path) |> Integer.parse() do
      :error -> 0
      {value, _} -> value
    end
  end

  defp read_slide_files() do
    Path.join([:code.priv_dir(:ui), "data", "slides"])
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
      <%= assigns.slides %>
      """
    end
  end
end
