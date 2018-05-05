defmodule Plug.DefaultRespContentType do
  @behaviour Plug

  def init(content_type) when content_type  |> is_binary(), do: content_type
  def init(_), do: raise ArgumentError, message: "content_type must be a String"

  def call(%Plug.Conn{} = conn, content_type) do
    conn
    |> Plug.Conn.put_resp_content_type(content_type)
  end
end
