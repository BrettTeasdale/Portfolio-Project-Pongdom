defmodule Pongdom.Repo.Migrations.AddRequestAssetResponsesTable do
  use Ecto.Migration

  def change do
    create table("request_asset_responses") do
      add :request_response_id, :integer
      add :http_response_code, :integer
      add :httpoison_error_slug, :string
      add :response_time, :integer
      timestamps()
    end
  end
end
