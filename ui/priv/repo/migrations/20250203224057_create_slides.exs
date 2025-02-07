defmodule Ui.Repo.Migrations.CreateSlides do
  use Ecto.Migration

  def change do
    create table(:slides) do
      add :order, :integer
      add :content, :string

      timestamps()
    end
  end
end
