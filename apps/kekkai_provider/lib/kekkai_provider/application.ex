defmodule KekkaiCore.Application do
  @moduledoc """
  Top level `Supervisor` for KekkaiCore.
  This module supervises the server cluster and the pid Registry,
  and also provides functions for them.
  """

  use Application

  @registry KekkaiCore.Registry

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: @registry},
      {KekkaiCore.Server, []}
    ]

    opts = [strategy: :one_for_one, name: KekkaiCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Create unique pid in pair of a given unique string, using Registry.
  Returns in a `:via` tuple style.
  """
  def process_name(id) when id |> is_integer, do: {:via, Registry, {@registry, id}}
  def process_name(id), do: raise ArgumentError, message: "id must be an integer. given: #{id}"
end
