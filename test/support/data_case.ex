defmodule Ecto.Ksuid.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Ksuid.TestRepo
      alias Ecto.Ksuid.TestSchema
      alias Ecto.Ksuid.RawTestSchema
    end
  end

  setup tags do
    Ecto.Ksuid.DataCase.setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Ecto.Ksuid.TestRepo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end
end
