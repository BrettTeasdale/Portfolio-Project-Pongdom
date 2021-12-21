defmodule PongdomWeb.DomainAccessTokenController do
  use PongdomWeb, :controller

  alias Pongdom.Accounts
  alias Pongdom.Accounts.DomainAccessToken

  def index(conn, _params) do
    domain_access_tokens = Accounts.list_domain_access_tokens()
    render(conn, "index.html", domain_access_tokens: domain_access_tokens)
  end

  def new(conn, _params) do
    changeset = Accounts.change_domain_access_token(%DomainAccessToken{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"domain_access_token" => domain_access_token_params}) do
    new_params = Map.put(domain_access_token_params, "token_filename", generate_token_filename()) 
                 |> Map.put("token_body", generate_token_body())
    
    case Accounts.create_domain_access_token(new_params) do
      {:ok, domain_access_token} ->
        conn
        |> put_flash(:info, "Domain access token created successfully.")
        |> redirect(to: Routes.domain_access_token_path(conn, :show, domain_access_token))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def download(conn, %{"id" => id}) do
    domain_access_token = Accounts.get_domain_access_token!(id)
    conn
    |> put_resp_content_type("text/plain")
    |> put_resp_header("content-disposition", "attachment; filename=\"#{domain_access_token.token_filename}\"")
    |> send_resp(200, domain_access_token.token_body)
  end

  def show(conn, %{"id" => id}) do
    domain_access_token = Accounts.get_domain_access_token!(id)
    render(conn, "show.html", domain_access_token: domain_access_token)
  end

  def edit(conn, %{"id" => id}) do
    domain_access_token = Accounts.get_domain_access_token!(id)
    changeset = Accounts.change_domain_access_token(domain_access_token)
    render(conn, "edit.html", domain_access_token: domain_access_token, changeset: changeset)
  end

  def update(conn, %{"id" => id, "domain_access_token" => domain_access_token_params}) do
    domain_access_token = Accounts.get_domain_access_token!(id)

    case Accounts.update_domain_access_token(domain_access_token, domain_access_token_params) do
      {:ok, domain_access_token} ->
        conn
        |> put_flash(:info, "Domain access token updated successfully.")
        |> redirect(to: Routes.domain_access_token_path(conn, :show, domain_access_token))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", domain_access_token: domain_access_token, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    domain_access_token = Accounts.get_domain_access_token!(id)
    {:ok, _domain_access_token} = Accounts.delete_domain_access_token(domain_access_token)

    conn
    |> put_flash(:info, "Domain access token deleted successfully.")
    |> redirect(to: Routes.domain_access_token_path(conn, :index))
  end

  defp generate_token_filename do
    random_text = for _ <- 1..16, into: "", do: <<Enum.random('abcdefghijklmnopqrstuvwxyz1234567890')>>
    "pongdom_" <> random_text <> ".txt"
  end

  defp generate_token_body do
    for _ <- 1..42, into: "", do: <<Enum.random('abcdefghijklmnopqrstuvwxyz1234567890')>>
  end
end
