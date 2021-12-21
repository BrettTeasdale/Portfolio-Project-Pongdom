defmodule PongdomWeb.DomainAccessTokenControllerTest do
  use PongdomWeb.ConnCase

  import Pongdom.AccountsFixtures

  @create_attrs %{domain: "some domain", token: "some token", token_filename: "some token_filename", user_id: 42}
  @update_attrs %{domain: "some updated domain", token: "some updated token", token_filename: "some updated token_filename", user_id: 43}
  @invalid_attrs %{domain: nil, token: nil, token_filename: nil, user_id: nil}

  describe "index" do
    test "lists all domain_access_tokens", %{conn: conn} do
      conn = get(conn, Routes.domain_access_token_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Domain access tokens"
    end
  end

  describe "new domain_access_token" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.domain_access_token_path(conn, :new))
      assert html_response(conn, 200) =~ "New Domain access token"
    end
  end

  describe "create domain_access_token" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.domain_access_token_path(conn, :create), domain_access_token: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.domain_access_token_path(conn, :show, id)

      conn = get(conn, Routes.domain_access_token_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Domain access token"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.domain_access_token_path(conn, :create), domain_access_token: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Domain access token"
    end
  end

  describe "edit domain_access_token" do
    setup [:create_domain_access_token]

    test "renders form for editing chosen domain_access_token", %{conn: conn, domain_access_token: domain_access_token} do
      conn = get(conn, Routes.domain_access_token_path(conn, :edit, domain_access_token))
      assert html_response(conn, 200) =~ "Edit Domain access token"
    end
  end

  describe "update domain_access_token" do
    setup [:create_domain_access_token]

    test "redirects when data is valid", %{conn: conn, domain_access_token: domain_access_token} do
      conn = put(conn, Routes.domain_access_token_path(conn, :update, domain_access_token), domain_access_token: @update_attrs)
      assert redirected_to(conn) == Routes.domain_access_token_path(conn, :show, domain_access_token)

      conn = get(conn, Routes.domain_access_token_path(conn, :show, domain_access_token))
      assert html_response(conn, 200) =~ "some updated domain"
    end

    test "renders errors when data is invalid", %{conn: conn, domain_access_token: domain_access_token} do
      conn = put(conn, Routes.domain_access_token_path(conn, :update, domain_access_token), domain_access_token: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Domain access token"
    end
  end

  describe "delete domain_access_token" do
    setup [:create_domain_access_token]

    test "deletes chosen domain_access_token", %{conn: conn, domain_access_token: domain_access_token} do
      conn = delete(conn, Routes.domain_access_token_path(conn, :delete, domain_access_token))
      assert redirected_to(conn) == Routes.domain_access_token_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.domain_access_token_path(conn, :show, domain_access_token))
      end
    end
  end

  defp create_domain_access_token(_) do
    domain_access_token = domain_access_token_fixture()
    %{domain_access_token: domain_access_token}
  end
end
