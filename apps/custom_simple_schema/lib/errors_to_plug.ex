defmodule SimpleSchema.Utilities.ErrorsToPlug do
  @moduledoc """
  Set errors to json views.
  """

  @doc """
  Sets errors as json friendly style.
  Will not set response status, nor perform the actual send.
  """
  def set_body(conn, reasons) when is_list(reasons) do
    json =
      %{
        errors: %{
          error: "Request parameter was wrong.",
          details: reasons |> Enum.map(fn {reason, place} -> %{position: place, reason: reason} end)
        }
      }
      |> Jason.encode!

    conn |> do_set_body(json)
  end

  # defp do_set_body(%Plug.Conn{resp_body: nil, state: :unset} = conn, body) do
  defp do_set_body(%Plug.Conn{} = conn, body) do
    %{conn | resp_body: body, state: :set}
  end
end
