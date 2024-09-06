defmodule Golfscor.Repo do
  use Ecto.Repo,
    otp_app: :golfscor,
    adapter: Ecto.Adapters.Postgres
end
