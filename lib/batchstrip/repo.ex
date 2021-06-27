"""
Pulled out POSTGRES & ecto configs:

defmodule Batchstrip.Repo do
  use Ecto.Repo,
    otp_app: :batchstrip,
    adapter: Ecto.Adapters.Postgres
end
"""
