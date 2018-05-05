defmodule KekkaiGateway.Endpoint.Apps.CreateParser do
  defmodule AttributesSchema do
    import SimpleSchema, only: [defschema: 2]

    defschema [
      id: :integer,
      consumer_secret: :string,
    ], tolerant: true
  end

  @spec parse!(map) :: AttributesSchema.t | no_return
  @doc """
  Parses a decoded json map into account struct.
  Raises if not following the simple schema.
  """
  def parse!(json_map) do
    SimpleSchema.from_json!(AttributesSchema, json_map)
  end
end
