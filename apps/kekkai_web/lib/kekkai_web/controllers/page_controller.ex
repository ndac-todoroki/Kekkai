defmodule KekkaiWeb.PageController do
  use KekkaiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
