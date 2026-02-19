defmodule ColocatedPostcssExample.Repo do
  use Ecto.Repo,
    otp_app: :colocated_postcss_example,
    adapter: Ecto.Adapters.SQLite3
end
