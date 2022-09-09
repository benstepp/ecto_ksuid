defmodule Ecto.Ksuid.TestRepo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ecto_ksuid,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    config
    |> Keyword.put(:url, "ecto://postgres:postgres@postgres/ecto_ksuid_test")
    |> Keyword.put(:pool, Ecto.Adapters.SQL.Sandbox)
    |> Keyword.put(:migration_primary_key, name: :id, type: :char, size: 27)
    |> Keyword.put(:migration_foreign_key, name: :id, type: :char, size: 27)
    |> then(&{:ok, &1})
  end
end
