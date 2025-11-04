defmodule BifrostApp.Repo do
  use Ecto.Repo,
    otp_app: :bifrost_app,
    adapter: Ecto.Adapters.Postgres
end
