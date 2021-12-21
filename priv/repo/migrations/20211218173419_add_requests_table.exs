defmodule Pongdom.Repo.Migrations.AddRequestsTable do
  use Ecto.Migration

  def change do
    create table("requests") do
      add :user_id, :integer
      add :uri, :string
      add :frequency_per_hour, :integer
      timestamps()
    end
  end
end
