defmodule KekkaiWeb.AppController do
  use KekkaiWeb, :controller

  plug Ueberauth

  alias KekkaiDb.ControlPanel
  alias KekkaiDb.ControlPanel.App

  # def index(conn, _params) do
  #   app = ControlPanel.list_app()
  #   render(conn, "index.html", app: app)
  # end

  def new(conn, _params) do
    changeset = ControlPanel.change_app(%App{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"app" => app_params}) do
    case ControlPanel.create_app(app_params) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App created successfully.")
        |> redirect(to: Routes.app_path(conn, :show, app))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    app = ControlPanel.get_app!(id)
    render(conn, "show.html", app: app)
  end

  def edit(conn, %{"id" => id}) do
    app = ControlPanel.get_app!(id)
    changeset = ControlPanel.change_app(app)
    render(conn, "edit.html", app: app, changeset: changeset)
  end

  def update(conn, %{"id" => id, "app" => app_params}) do
    app = ControlPanel.get_app!(id)

    case ControlPanel.update_app(app, app_params) do
      {:ok, app} ->
        conn
        |> put_flash(:info, "App updated successfully.")
        |> redirect(to: Routes.app_path(conn, :show, app))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", app: app, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    app = ControlPanel.get_app!(id)
    {:ok, _app} = ControlPanel.delete_app(app)

    conn
    |> put_flash(:info, "App deleted successfully.")
    |> redirect(to: Routes.app_path(conn, :index))
  end
end
