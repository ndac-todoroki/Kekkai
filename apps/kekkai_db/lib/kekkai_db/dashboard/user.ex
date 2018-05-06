defmodule KekkaiDB.Dashboard.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields [:twitter_screen_name, :twitter_id, :twitter_name]
  schema "users" do
    field :twitter_screen_name, :string
    field :twitter_id, :integer
    field :twitter_name, :string

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:twitter_screen_name, :twitter_id, :twitter_name])
    |> validate_required(@required_fields)
  end
end
