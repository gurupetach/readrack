defmodule Readrack.Repo do
  use Ecto.Repo,
    otp_app: :readrack,
    adapter: Ecto.Adapters.Postgres
end
