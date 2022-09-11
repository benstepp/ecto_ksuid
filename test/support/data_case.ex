defmodule EctoKsuid.DataCase do
  @moduledoc """
  Test Case template providing database access
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoKsuid, as: Type
      alias EctoKsuid.TestRepo, as: Repo
      alias EctoKsuid.Options
      alias EctoKsuid.Validator
      alias EctoKsuid.TestSchema
      alias EctoKsuid.RawTestSchema

      import EctoKsuid.DataCase, except: [setup_sandbox: 1]
    end
  end

  setup tags do
    EctoKsuid.DataCase.setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(EctoKsuid.TestRepo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  def ksuid() do
    EctoKsuid.generate()
  end

  @doc """
  Changeset to make testing integration schemas easier.

  It casts all fields that were defined on a given association.
  """
  @spec changeset(struct(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{})

  def changeset(%struct_name{} = struct, params) do
    struct
    |> Ecto.Changeset.cast(params, struct_name.__schema__(:fields))
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
