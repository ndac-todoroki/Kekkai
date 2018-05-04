defmodule KekkaiServerTest do
  use ExUnit.Case
  doctest KekkaiServer

  test "greets the world" do
    assert KekkaiServer.hello() == :world
  end
end
