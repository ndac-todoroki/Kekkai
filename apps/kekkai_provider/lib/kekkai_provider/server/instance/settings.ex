defmodule KekkaiProvider.Server.Instance.Settings do
  @moduledoc """
  Struct representing Kekkai instance settings.

  ### Keys
  * `instance_id`: a unique string name representing a server instance.
  * `process_name`: a pid or a `:via` tuple which is a unique identifier of the GenServer.
  """

  @struct_keys [
    instance_id: nil,
    process_name: nil,
    secret: "",
    filters: [],
    connections: [],
  ]

  defstruct @struct_keys

  def permitted_keys, do: @struct_keys
end
