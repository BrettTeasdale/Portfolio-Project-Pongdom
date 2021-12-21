defmodule Pongdom.Accounts.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :user_id, :integer
    field :uri, :string
    field :frequency_per_hour, :integer

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:user_id, :uri, :frequency_per_hour])
    |> validate_required([:user_id, :uri, :frequency_per_hour])
  end
end
