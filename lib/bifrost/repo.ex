defmodule Bifrost.Repo do
  use Ecto.Repo,
    otp_app: :bifrost,
    adapter: Ecto.Adapters.Postgres
end
