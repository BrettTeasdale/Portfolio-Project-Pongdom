defmodule Pongdom.Repo do
  use Ecto.Repo,
    otp_app: :pongdom,
    adapter: Ecto.Adapters.Postgres
end
