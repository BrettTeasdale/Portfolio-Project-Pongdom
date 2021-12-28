defmodule PongdomWeb.DomainRateLimitingControllerTest do
  use PongdomWeb.ConnCase

  import Pongdom.AccountsFixtures

  @create_attrs %{domain: "some domain", limit: 42, scale_ms: 42, user_id: 42}
  @update_attrs %{domain: "some updated domain", limit: 43, scale_ms: 43, user_id: 43}
  @invalid_attrs %{domain: nil, limit: nil, scale_ms: nil, user_id: nil}

  describe "index" do
    test "lists all domain_rate_limiting", %{conn: conn} do
      conn = get(conn, Routes.domain_rate_limiting_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Domain rate limiting"
    end
  end

  describe "new domain_rate_limiting" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.domain_rate_limiting_path(conn, :new))
      assert html_response(conn, 200) =~ "New Domain rate limiting"
    end
  end

  describe "create domain_rate_limiting" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.domain_rate_limiting_path(conn, :create), domain_rate_limiting: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.domain_rate_limiting_path(conn, :show, id)

      conn = get(conn, Routes.domain_rate_limiting_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Domain rate limiting"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.domain_rate_limiting_path(conn, :create), domain_rate_limiting: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Domain rate limiting"
    end
  end

  describe "edit domain_rate_limiting" do
    setup [:create_domain_rate_limiting]

    test "renders form for editing chosen domain_rate_limiting", %{conn: conn, domain_rate_limiting: domain_rate_limiting} do
      conn = get(conn, Routes.domain_rate_limiting_path(conn, :edit, domain_rate_limiting))
      assert html_response(conn, 200) =~ "Edit Domain rate limiting"
    end
  end

  describe "update domain_rate_limiting" do
    setup [:create_domain_rate_limiting]

    test "redirects when data is valid", %{conn: conn, domain_rate_limiting: domain_rate_limiting} do
      conn = put(conn, Routes.domain_rate_limiting_path(conn, :update, domain_rate_limiting), domain_rate_limiting: @update_attrs)
      assert redirected_to(conn) == Routes.domain_rate_limiting_path(conn, :show, domain_rate_limiting)

      conn = get(conn, Routes.domain_rate_limiting_path(conn, :show, domain_rate_limiting))
      assert html_response(conn, 200) =~ "some updated domain"
    end

    test "renders errors when data is invalid", %{conn: conn, domain_rate_limiting: domain_rate_limiting} do
      conn = put(conn, Routes.domain_rate_limiting_path(conn, :update, domain_rate_limiting), domain_rate_limiting: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Domain rate limiting"
    end
  end

  describe "delete domain_rate_limiting" do
    setup [:create_domain_rate_limiting]

    test "deletes chosen domain_rate_limiting", %{conn: conn, domain_rate_limiting: domain_rate_limiting} do
      conn = delete(conn, Routes.domain_rate_limiting_path(conn, :delete, domain_rate_limiting))
      assert redirected_to(conn) == Routes.domain_rate_limiting_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.domain_rate_limiting_path(conn, :show, domain_rate_limiting))
      end
    end
  end

  defp create_domain_rate_limiting(_) do
    domain_rate_limiting = domain_rate_limiting_fixture()
    %{domain_rate_limiting: domain_rate_limiting}
  end
end
