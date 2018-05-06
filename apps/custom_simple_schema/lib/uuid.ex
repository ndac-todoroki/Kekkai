defmodule SimpleSchema.Type.UUID do
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
    case UUID.info(value) do
      {:ok, _info} -> {:ok, value}
      {:error, info} -> {:error, info}
    end
  end

  @impl SimpleSchema
  def to_json(_schema, value, _opts) do
    case UUID.info(value) do
      {:ok, _info} -> {:ok, value}
      {:error, info} -> {:error, info}
    end
  end
end
