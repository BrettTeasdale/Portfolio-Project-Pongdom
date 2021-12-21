defmodule Pongdom.Repo.Migrations.CreateDomainAccessTokens do
  use Ecto.Migration

  def change do
    create table(:domain_access_tokens) do
      add :user_id, :integer
      add :domain, :string
      add :token_filename, :string
      add :token_body, :string

      timestamps()
    end
  end
end
