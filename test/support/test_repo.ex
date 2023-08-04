defmodule EctoKsuid.TestRepo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :ecto_ksuid,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    config
    |> Keyword.put(:url, url())
    |> Keyword.put(:pool, Ecto.Adapters.SQL.Sandbox)
    |> Keyword.put(:migration_primary_key, name: :id, type: :"char(27)")
    |> Keyword.put(:migration_foreign_key, name: :id, type: :"char(27)")
    |> then(&{:ok, &1})
  end

  defp url() do
    System.get_env("DATABASE_URL", "ecto://postgres:postgres@localhost/ecto_ksuid_test")
  end
end
