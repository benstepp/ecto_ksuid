defmodule Ecto.Ksuid.AutogenerateFalseTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule AutogenerateFalse do
    use Ecto.Schema

    @primary_key {:id, Ecto.Ksuid, autogenerate: false}

    schema "test_schemas" do
      field(:public_id, Ecto.Ksuid, autogenerate: false)
    end
  end

  test "postgres errors when no id passed (primary_key means null not allowed)" do
    assert_raise Postgrex.Error, fn ->
      %AutogenerateFalse{}
      |> changeset()
      |> Repo.insert()
    end
  end

  test "does not auto generate a public_id" do
    params = %{
      id: ksuid()
    }

    assert {:ok, result} =
             %AutogenerateFalse{}
             |> changeset(params)
             |> Repo.insert()

    assert result.id == params.id
    assert result.public_id == nil
  end

  test "can pass a public_id and not get overwritten" do
    params = %{
      id: ksuid(),
      public_id: ksuid()
    }

    assert {:ok, result} =
             %AutogenerateFalse{}
             |> changeset(params)
             |> Repo.insert()

    assert result.id == params.id
    assert result.public_id == params.public_id
  end
end
