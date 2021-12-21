defmodule Pongdom.Accounts.RequestResponse do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "request_responses" do
      field :request_id, :integer
      field :http_response_code, :integer
      field :httpoison_error_slug, :string
      field :response_time, :integer
      timestamps()
    end
end