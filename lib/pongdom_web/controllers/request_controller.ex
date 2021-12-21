defmodule PongdomWeb.RequestController do
  use PongdomWeb, :controller

  alias Pongdom.Accounts
  alias Pongdom.Accounts.Request

  def index(conn, _params) do
    requests = Accounts.list_requests()
    render(conn, "index.html", requests: requests)
  end

  def new(conn, _params) do
    changeset = Accounts.change_request(%Request{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"request" => request_params}) do
    case Accounts.create_request(request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request created successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Accounts.get_request!(id)
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}) do
    request = Accounts.get_request!(id)
    changeset = Accounts.change_request(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Accounts.get_request!(id)

    case Accounts.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Accounts.get_request!(id)
    {:ok, _request} = Accounts.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: Routes.request_path(conn, :index))
  end
end
