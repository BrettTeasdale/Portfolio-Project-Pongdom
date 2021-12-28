defmodule Pongdom.Repo.Migrations.AddDomainRateLimiting do
  use Ecto.Migration

  def change do
    create table("domain_rate_limiting") do
      add :user_id, :integer
      add :domain, :string
      add :scale_ms, :integer
      add :limit, :integer
  
      timestamps()
    end
  end
end
