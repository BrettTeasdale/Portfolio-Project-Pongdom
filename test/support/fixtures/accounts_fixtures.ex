defmodule Pongdom.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pongdom.Accounts` context.
  """

  def unique_users_email, do: "users#{System.unique_integer()}@example.com"
  def valid_users_password, do: "hello world!"

  def valid_users_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_users_email(),
      password: valid_users_password()
    })
  end

  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> valid_users_attributes()
      |> Pongdom.Accounts.register_users()

    users
  end

  def extract_users_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a request.
  """
  def request_fixture(attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{
        frequency_per_hour: 42,
        uri: "some uri",
        user_id: 42
      })
      |> Pongdom.Accounts.create_request()

    request
  end

  @doc """
  Generate a domain_access_token.
  """
  def domain_access_token_fixture(attrs \\ %{}) do
    {:ok, domain_access_token} =
      attrs
      |> Enum.into(%{
        domain: "some domain",
        token: "some token",
        token_filename: "some token_filename",
        user_id: 42
      })
      |> Pongdom.Accounts.create_domain_access_token()

    domain_access_token
  end
end
