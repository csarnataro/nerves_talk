defmodule Ui.MigrationHelpers do
  require Logger
  alias Ui.Repo
  alias Ui.Slides
  alias Ui.Slides.Slide

  @app :ui

  def migrate() do
    IO.puts("*************************")
    IO.puts("Running migration in helper")
    IO.puts("*************************")

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end

    cond do
      Slides.list_slides()
      |> Enum.count() == 0 ->
        add_slides()

      true ->
        nil
    end
  end

  defp repos() do
    _ = Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp get_order(path) do
    case Path.basename(path) |> Integer.parse() do
      :error -> 0
      {value, _} -> value
    end
  end

  defp read_order_and_content(filename) do
    order = filename |> Path.basename() |> String.split(".") |> Enum.at(0) |> String.to_integer()
    content = File.read!(filename)

    %{order: order, content: content}
  end

  defp add_slides() do
    Path.join([:code.priv_dir(:ui), "data", "slides"])
    |> Path.join("*.md")
    |> Path.wildcard()
    |> Enum.sort(&(get_order(&1) < get_order(&2)))
    |> Enum.map(&read_order_and_content/1)
    |> tap(&IO.inspect/1)
    |> Enum.each(fn %{content: content, order: order} ->
      Repo.insert!(%Slide{order: order, content: content})
    end)

    #  |> Enum.join("\n\n---\n\n")

    # Repo.insert!(%Slides{order: 10, content: "# Title of slide 1"})
    # Repo.insert!(%Slides{order: 20, content: "# Title of slide 1"})
    # Repo.insert!(%Slides{order: 30, content: "# Title of slide 1"})
  end
end
