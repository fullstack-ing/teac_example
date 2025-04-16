defmodule TeacExample.Repo do
  use Ecto.Repo,
    otp_app: :teac_example,
    adapter: Ecto.Adapters.Postgres
end
