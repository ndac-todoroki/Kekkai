defmodule KekkaiDb.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :twitter_screen_name, :string
      add :twitter_id, :integer
      add :twitter_name, :string

      timestamps()
    end

    create unique_index(:users, [:twitter_id])
  end
end
