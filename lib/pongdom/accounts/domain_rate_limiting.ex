defmodule Pongdom.Accounts.DomainRateLimiting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "domain_rate_limiting" do
    field :domain, :string
    field :limit, :integer
    field :scale_ms, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(domain_rate_limiting, attrs) do
    domain_rate_limiting
    |> cast(attrs, [:user_id, :domain, :scale_ms, :limit])
    |> validate_required([:user_id, :domain, :scale_ms, :limit])
  end
end
