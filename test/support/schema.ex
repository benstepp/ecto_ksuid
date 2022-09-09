defmodule Ecto.Ksuid.TestSchema do
  use Ecto.Schema

  @primary_key {:id, Ecto.Ksuid, autogenerate: true, prefix: "test_"}
  schema "test_schemas" do
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:id])
  end
end

defmodule Ecto.Ksuid.RawTestSchema do
  use Ecto.Schema

  @primary_key {:id, :string, []}
  schema "test_schemas" do
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:id])
  end
end
