defmodule EctoKsuid.PrimaryKeyFieldTest do
  use EctoKsuid.DataCase, async: true

  defmodule PrimaryKeyField do
    use Ecto.Schema

    @primary_key false

    schema "test_schemas" do
      field(:id, EctoKsuid, primary_key: true, autogenerate: true, prefix: "pkey_")
    end
  end

  test "can autogenerate an id" do
    assert {:ok, result} =
             %PrimaryKeyField{}
             |> changeset()
             |> Repo.insert()

    assert "pkey_" <> ksuid = result.id
    assert {:ok, _valid} = Validator.is_valid?(ksuid)
  end

  test "only the ksuid is stored in the database" do
    assert {:ok, result} =
             %PrimaryKeyField{}
             |> changeset()
             |> Repo.insert()

    assert "pkey_" <> ksuid = result.id
    assert db = Repo.one(RawTestSchema)
    assert db.id == ksuid
  end

  test "can pass your own id and not auto-generate" do
    ksuid = ksuid()

    assert {:ok, result} =
             %PrimaryKeyField{}
             |> changeset(%{id: "pkey_#{ksuid}"})
             |> Repo.insert()

    assert "pkey_" <> ^ksuid = result.id
  end

  test "errors when passed invalid EctoKsuid (no prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PrimaryKeyField{}
             |> changeset(%{id: ksuid})
             |> Repo.insert()

    assert errors_on(changeset).id
  end

  test "errors when passed invalid EctoKsuid (wrong prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PrimaryKeyField{}
             |> changeset(%{id: "wrong_#{ksuid}"})
             |> Repo.insert()

    assert errors_on(changeset).id
  end

  test "can Repo.get by id" do
    {:ok, schema} =
      %PrimaryKeyField{}
      |> changeset()
      |> Repo.insert()

    assert result = Repo.get(PrimaryKeyField, schema.id)
    assert result.id == schema.id
  end

  test "can use Ecto.Query expressions by id" do
    {:ok, schema} =
      %PrimaryKeyField{}
      |> changeset()
      |> Repo.insert()

    query =
      from(np in PrimaryKeyField,
        where: np.id == ^schema.id,
        limit: 1
      )

    assert result = Repo.one(query)
    assert result.id == schema.id
  end

  test "can use Ecto.Query macros by id" do
    {:ok, schema} =
      %PrimaryKeyField{}
      |> changeset()
      |> Repo.insert()

    query =
      PrimaryKeyField
      |> where([np], np.id == ^schema.id)
      |> limit(1)

    assert result = Repo.one(query)
    assert result.id == schema.id
  end

  test "querying without prefix errors" do
    {:ok, schema} =
      %PrimaryKeyField{}
      |> changeset()
      |> Repo.insert()

    "pkey_" <> ksuid = schema.id

    assert_raise Ecto.Query.CastError, fn ->
      Repo.get(PrimaryKeyField, ksuid)
    end
  end
end
