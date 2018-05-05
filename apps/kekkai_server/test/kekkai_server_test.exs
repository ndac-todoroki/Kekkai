defmodule KekkaiGatewayTest do
  use ExUnit.Case
  doctest KekkaiGateway

  test "greets the world" do
    assert KekkaiGateway.hello() == :world
  end
end
