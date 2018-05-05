defmodule KekkaiGateway.Parsers.ID do
  # TODO: change this into a Plug!
  # it should parse the id from the parameters, and replace it with the integer,
  # otherwise it should raise and return an error JSON.

  defmodule ParseError do
    defexception [
      message: "The URL format is wrong.",
      plug_status: 422,
    ]
  end

  def parse!(id) when is_binary(id) do
    id
    |> Integer.parse()
    |> judge_parse!()
  end

  defp judge_parse!({id, ""}), do: id
  defp judge_parse!(_), do: raise ParseError
end
