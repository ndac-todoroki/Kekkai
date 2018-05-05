defmodule SimpleSchema.Type.IntegerString do
  @moduledoc """
  UUID types such as `"2017-12-25"` for SimpleSchema.
  """

  @behaviour SimpleSchema

  @impl SimpleSchema
  def schema(_opts) do
    :string
  end

  @impl SimpleSchema
  def from_json(_schema, value, _opts) do
    case Integer.parse(value, 10) do
      {integer, ""} -> {:ok, integer}
      _ -> {:error, :invalid_format}
    end
  end

  @impl SimpleSchema
  def to_json(_schema, value, _opts) do
    {:ok, value |> to_string}
  end
end
