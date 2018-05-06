defmodule SimpleSchema.Type.IntegerString do
  @moduledoc """
  Accepts strings which represent valid base-10 integers, or integers itself
  """

  @behaviour SimpleSchema

  @impl SimpleSchema
  def schema(_opts) do
    :any
  end

  @impl SimpleSchema
  def from_json(_schema, value, _opts) when value |> is_binary do
    case Integer.parse(value, 10) do
      {integer, ""} ->
        {:ok, integer}
      _ ->
        from_json_error(value)
    end
  end

  @impl SimpleSchema
  def from_json(_schema, value, _opts) when value |> is_integer do
    {:ok, value}
  end

  @impl SimpleSchema
  def from_json(_schema, value, _opts), do: from_json_error(value)

  defp from_json_error(value) do
    {:error, {:invalid_argument, "value `#{value}` is not or cannot be converted into an integer."}}
  end

  @impl SimpleSchema
  def to_json(_schema, value, _opts) do
    {:ok, value |> to_string}
  end
end
