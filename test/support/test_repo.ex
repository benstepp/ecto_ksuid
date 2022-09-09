defmodule Ecto.Ksuid.TestRepo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ecto_ksuid,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    config
    |> Keyword.put(:url, "ecto://postgres:postgres@postgres/ecto_ksuid_test")
    |> Keyword.put(:pool, Ecto.Adapters.SQL.Sandbox)
    |> then(&{:ok, &1})
  end
end
