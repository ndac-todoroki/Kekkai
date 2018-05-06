defmodule Plug.FilterByIP do
  @moduledoc """
  Currently only white-listing.
  This plug needs `plug RemoteIp` declared beforehand.

  ## Usage
      plug Plug.FilterByIP, "127.0.0.1"

      # or
      plug Plug.FilterByIP, ~w(127.0.0.1 192.168.0.0/16)
  """

  defstruct addresses: [], cidr_blocks: []

  @behaviour Plug

  @forbidden %{errors: %{message: "Forbidden."}} |> Jason.encode!

  def init(addresses) when addresses |> is_list, do: do_init(addresses, %__MODULE__{})
  def init(address), do: do_init([address], %__MODULE__{})

  defp do_init([], %__MODULE__{} = result), do: result
  defp do_init([ip_addr | tail], %__MODULE__{} = result) when ip_addr |> is_binary do
    cond do
      ~r{.+/[0-9a-f]*\z} |> Regex.match?(ip_addr) ->
        new_result =
          update_in(result.cidr_blocks, fn list -> [ip_addr |> InetCidr.parse() | list] end)
        do_init(tail, new_result)

      :else ->
        new_result =
          update_in(result.addresses, fn list -> [ip_addr |> InetCidr.parse_address!() | list] end)
        do_init(tail, new_result)
    end
  end

  def call(%Plug.Conn{} = conn, %__MODULE__{} = whitelist) do
    if conn.remote_ip |> permitted?(whitelist) do
      conn
    else
      conn
      |> Plug.Conn.send_resp(:forbidden, @forbidden)
      |> Plug.Conn.halt # It's important to halt connection once we send a response early
    end
  end

  def permitted?(ip_addr, %__MODULE__{addresses: addresses, cidr_blocks: blocks}) do
    cond do
      ip_addr in addresses ->
        true
      Enum.any?(blocks, fn block -> InetCidr.contains?(block, ip_addr) end) ->
        true
      :else ->
        false
    end
  end
end
