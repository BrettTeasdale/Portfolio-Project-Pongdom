defmodule PongdomWeb.DomainRateLimitingController do
  use PongdomWeb, :controller

  alias Pongdom.Accounts
  alias Pongdom.Accounts.DomainRateLimiting

  def index(conn, _params) do
    domain_rate_limiting = Accounts.list_domain_rate_limiting()
    render(conn, "index.html", domain_rate_limiting: domain_rate_limiting)
  end

  def new(conn, _params) do
    changeset = Accounts.change_domain_rate_limiting(%DomainRateLimiting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"domain_rate_limiting" => domain_rate_limiting_params}) do
    case Accounts.create_domain_rate_limiting(domain_rate_limiting_params) do
      {:ok, domain_rate_limiting} ->
        conn
        |> put_flash(:info, "Domain rate limiting created successfully.")
        |> redirect(to: Routes.domain_rate_limiting_path(conn, :show, domain_rate_limiting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    domain_rate_limiting = Accounts.get_domain_rate_limiting!(id)
    render(conn, "show.html", domain_rate_limiting: domain_rate_limiting)
  end

  def edit(conn, %{"id" => id}) do
    domain_rate_limiting = Accounts.get_domain_rate_limiting!(id)
    changeset = Accounts.change_domain_rate_limiting(domain_rate_limiting)
    render(conn, "edit.html", domain_rate_limiting: domain_rate_limiting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "domain_rate_limiting" => domain_rate_limiting_params}) do
    domain_rate_limiting = Accounts.get_domain_rate_limiting!(id)

    case Accounts.update_domain_rate_limiting(domain_rate_limiting, domain_rate_limiting_params) do
      {:ok, domain_rate_limiting} ->
        conn
        |> put_flash(:info, "Domain rate limiting updated successfully.")
        |> redirect(to: Routes.domain_rate_limiting_path(conn, :show, domain_rate_limiting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", domain_rate_limiting: domain_rate_limiting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    domain_rate_limiting = Accounts.get_domain_rate_limiting!(id)
    {:ok, _domain_rate_limiting} = Accounts.delete_domain_rate_limiting(domain_rate_limiting)

    conn
    |> put_flash(:info, "Domain rate limiting deleted successfully.")
    |> redirect(to: Routes.domain_rate_limiting_path(conn, :index))
  end
end
