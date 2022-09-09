defmodule Ecto.Ksuid.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Ksuid, as: Type
      alias Ecto.Ksuid.Options
      alias Ecto.Ksuid.TestRepo
      alias Ecto.Ksuid.TestSchema
      alias Ecto.Ksuid.RawTestSchema

      import Ecto.Ksuid.DataCase, except: [setup_sandbox: 1]
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

  def ksuid() do
    Ksuid.generate()
  end
end
