defmodule Ecto.Ksuid.PublicIdTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule PublicId do
    use Ecto.Schema

    @primary_key {:id, Ecto.Ksuid, autogenerate: true}

    schema "test_schemas" do
      field(:public_id, Ecto.Ksuid, autogenerate: true, prefix: "public_")
    end
  end

  test "can autogenerate a field" do
    assert {:ok, result} =
             %PublicId{}
             |> changeset()
             |> Repo.insert()

    assert "public_" <> ksuid = result.public_id
    assert {:ok, _valid} = Validator.is_valid?(ksuid)
  end

  test "only the ksuid is stored in the database" do
    assert {:ok, result} =
             %PublicId{}
             |> changeset()
             |> Repo.insert()

    assert "public_" <> ksuid = result.public_id
    assert db = Repo.one(RawTestSchema)
    assert db.public_id == ksuid
  end

  test "can pass your own id and not auto-generate" do
    ksuid = ksuid()

    assert {:ok, result} =
             %PublicId{}
             |> changeset(%{public_id: "public_#{ksuid}"})
             |> Repo.insert()

    assert "public_" <> ^ksuid = result.public_id
  end

  test "errors when passed invalid Ecto.Ksuid (no prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PublicId{}
             |> changeset(%{public_id: ksuid})
             |> Repo.insert()

    assert errors_on(changeset).public_id
  end

  test "errors when passed invalid Ecto.Ksuid (wrong prefix)" do
    ksuid = ksuid()

    assert {:error, changeset} =
             %PublicId{}
             |> changeset(%{public_id: "wrong_#{ksuid}"})
             |> Repo.insert()

    assert errors_on(changeset).public_id
  end
end
