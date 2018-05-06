defmodule KekkaiDb.Repo.Migrations.CreateApps do
  use Ecto.Migration

  def change do
    create table(:apps, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :name, :string, null: false
      add :consumer_secret, :string, null: false
      add :twitter_app_id, :integer, null: false

      timestamps()
    end

    create unique_index(:apps, [:twitter_app_id])
  end
end
