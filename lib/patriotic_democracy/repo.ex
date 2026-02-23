defmodule PatrioticDemocracy.Repo do
  use Ecto.Repo,
    otp_app: :patriotic_democracy,
    adapter: Ecto.Adapters.Postgres
end
