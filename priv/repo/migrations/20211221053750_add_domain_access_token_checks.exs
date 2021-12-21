defmodule Pongdom.Repo.Migrations.AddDomainAccessTokenChecks do
  use Ecto.Migration

  def change do
    create table("domain_access_token_checks") do
      add :domain_access_token_id, :integer
      add :success, :boolean
      
      timestamps()
    end
  end
end
