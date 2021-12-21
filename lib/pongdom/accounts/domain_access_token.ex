defmodule Pongdom.Accounts.DomainAccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "domain_access_tokens" do
    field :user_id, :integer
    field :domain, :string
    field :token_filename, :string
    field :token_body, :string

    timestamps()
  end

  @doc false
  def changeset(domain_access_token, attrs) do
    domain_access_token
    |> cast(attrs, [:user_id, :domain, :token_filename, :token_body])
    |> validate_required([:user_id, :domain, :token_filename, :token_body])
  end
end
