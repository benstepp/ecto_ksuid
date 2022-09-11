defmodule EctoKsuid.NoPrefixTest do
  use EctoKsuid.DataCase, async: true

  defmodule NoPrefix do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, autogenerate: true}

    schema "test_schemas" do
    end
  end

  test "when not passing prefix it does not add one" do
    assert {:ok, result} =
             %NoPrefix{}
             |> changeset()
             |> Repo.insert()

    assert {:ok, _ksuid} = Validator.is_valid?(result.id)
  end

  test "can Repo.get by id" do
    {:ok, schema} =
      %NoPrefix{}
      |> changeset()
      |> Repo.insert()

    assert result = Repo.get(NoPrefix, schema.id)
    assert result.id == schema.id
  end

  test "can use Ecto.Query expressions by id" do
    {:ok, schema} =
      %NoPrefix{}
      |> changeset()
      |> Repo.insert()

    query =
      from(np in NoPrefix,
        where: np.id == ^schema.id,
        limit: 1
      )

    assert result = Repo.one(query)
    assert result.id == schema.id
  end

  test "can use Ecto.Query macros by id" do
    {:ok, schema} =
      %NoPrefix{}
      |> changeset()
      |> Repo.insert()

    query =
      NoPrefix
      |> where([np], np.id == ^schema.id)
      |> limit(1)

    assert result = Repo.one(query)
    assert result.id == schema.id
  end

  test "querying with a prefix errors" do
    {:ok, schema} =
      %NoPrefix{}
      |> changeset()
      |> Repo.insert()

    assert_raise Ecto.Query.CastError, fn ->
      Repo.get(NoPrefix, "prefix_#{schema.id}")
    end
  end
end
