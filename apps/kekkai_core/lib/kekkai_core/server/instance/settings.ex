defmodule KekkaiCore.Server.Instance.Settings do
  @moduledoc """
  Struct representing Kekkai instance settings.

  ### Keys
  * `instance_id`: a unique string name representing a server instance.
  * `process_name`: a pid or a `:via` tuple which is a unique identifier of the GenServer.
  """

  @struct_keys [
    instance_id: nil,
    process_name: nil,
    stash_pid: nil,
    consumer_secret: "",
    noise: "",  # webhook urlの末尾につけて識別するやつ
    filters: [],
    connections: [],
  ]

  defstruct @struct_keys

  def permitted_keys, do: @struct_keys

  def webhook_url(%__MODULE__{} = settings) do
    # FIXME: move this to config
    base = "https://www.jinro.club"
    "#{base}/webhooks/#{settings.instance_id}/#{settings.noise}"
  end
end
