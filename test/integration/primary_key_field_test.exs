defmodule Ecto.Ksuid.PrimaryKeyFieldTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule PrimaryKeyField do
    use Ecto.Schema

    @primary_key false

    schema "test_schemas" do
      field(:id, Ecto.Ksuid, primary_key: true, autogenerate: true, prefix: "pkey_")
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

  test "errors when passed invalid Ecto.Ksuid (no prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PrimaryKeyField{}
             |> changeset(%{id: ksuid})
             |> Repo.insert()

    assert errors_on(changeset).id
  end

  test "errors when passed invalid Ecto.Ksuid (wrong prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PrimaryKeyField{}
             |> changeset(%{id: "wrong_#{ksuid}"})
             |> Repo.insert()

    assert errors_on(changeset).id
  end
end
