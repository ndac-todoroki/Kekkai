defmodule KekkaiWeb.AppControllerTest do
  use KekkaiWeb.ConnCase

  alias KekkaiDb.ControlPanel

  @create_attrs %{app_id: 42, consumer_key: "some consumer_key", consumer_secret: "some consumer_secret"}
  @update_attrs %{app_id: 43, consumer_key: "some updated consumer_key", consumer_secret: "some updated consumer_secret"}
  @invalid_attrs %{app_id: nil, consumer_key: nil, consumer_secret: nil}

  def fixture(:app) do
    {:ok, app} = ControlPanel.create_app(@create_attrs)
    app
  end

  describe "index" do
    test "lists all app", %{conn: conn} do
      conn = get conn, Routes.app_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing App"
    end
  end

  describe "new app" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.app_path(conn, :new)
      assert html_response(conn, 200) =~ "New App"
    end
  end

  describe "create app" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.app_path(conn, :create), app: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.app_path(conn, :show, id)

      conn = get conn, Routes.app_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show App"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.app_path(conn, :create), app: @invalid_attrs
      assert html_response(conn, 200) =~ "New App"
    end
  end

  describe "edit app" do
    setup [:create_app]

    test "renders form for editing chosen app", %{conn: conn, app: app} do
      conn = get conn, Routes.app_path(conn, :edit, app)
      assert html_response(conn, 200) =~ "Edit App"
    end
  end

  describe "update app" do
    setup [:create_app]

    test "redirects when data is valid", %{conn: conn, app: app} do
      conn = put conn, Routes.app_path(conn, :update, app), app: @update_attrs
      assert redirected_to(conn) == Routes.app_path(conn, :show, app)

      conn = get conn, Routes.app_path(conn, :show, app)
      assert html_response(conn, 200) =~ "some updated consumer_key"
    end

    test "renders errors when data is invalid", %{conn: conn, app: app} do
      conn = put conn, Routes.app_path(conn, :update, app), app: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit App"
    end
  end

  describe "delete app" do
    setup [:create_app]

    test "deletes chosen app", %{conn: conn, app: app} do
      conn = delete conn, Routes.app_path(conn, :delete, app)
      assert redirected_to(conn) == Routes.app_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.app_path(conn, :show, app)
      end
    end
  end

  defp create_app(_) do
    app = fixture(:app)
    {:ok, app: app}
  end
end
