defmodule CustomSimpleSchemaTest do
  use ExUnit.Case
  doctest CustomSimpleSchema

  test "greets the world" do
    assert CustomSimpleSchema.hello() == :world
  end
end
