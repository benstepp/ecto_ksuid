defmodule Ecto.Ksuid.BaseSchemaTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule BaseSchema do
    defmacro __using__(opts \\ []) do
      options = Keyword.merge(opts, autogenerate: true)

      quote do
        use Ecto.Schema

        @primary_key {:id, Ecto.Ksuid, unquote(options)}
        @foreign_key_type Ecto.Ksuid
      end
    end
  end

  defmodule NoPrefix do
    use BaseSchema

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

  defmodule WithPrefix do
    use BaseSchema, prefix: "macro_"

    schema "test_schemas" do
    end
  end

  test "when passing prefix it adds one" do
    assert {:ok, result} =
             %WithPrefix{}
             |> changeset()
             |> Repo.insert()

    assert "macro_" <> ksuid = result.id
    assert {:ok, _ksuid} = Validator.is_valid?(ksuid)
  end
end
