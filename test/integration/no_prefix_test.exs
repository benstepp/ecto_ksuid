defmodule Ecto.Ksuid.NoPrefixTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule NoPrefix do
    use Ecto.Schema

    @primary_key {:id, Ecto.Ksuid, autogenerate: true}

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
end
