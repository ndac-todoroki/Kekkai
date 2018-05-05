defmodule KekkaiCore.Server.Instance.Worker.CrcTestParser do
  defmodule Schema do
    import SimpleSchema, only: [defschema: 2]

    defschema [
      id: :integer,
      secret: :string,
      crc_token: :string,
    ], tolerant: true
  end

  @spec parse!(map) :: Schema.t | no_return
  @doc """
  Parses a decoded json map into account struct.
  Raises if not following the simple schema.
  """
  def parse!(json_map) do
    SimpleSchema.from_json!(Schema, json_map)
  end
end
