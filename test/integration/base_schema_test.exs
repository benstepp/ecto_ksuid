defmodule EctoKsuid.BaseSchemaTest do
  use EctoKsuid.DataCase, async: true

  defmodule BaseSchema do
    defmacro __using__(opts \\ []) do
      options = Keyword.merge(opts, autogenerate: true)

      quote do
        use Ecto.Schema

        @primary_key {:id, EctoKsuid, unquote(options)}
        @foreign_key_type EctoKsuid
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

  defmodule Parent do
    use BaseSchema, prefix: "parent_"

    schema "test_schemas" do
      has_one(:child, Child)
    end
  end

  defmodule Child do
    use BaseSchema, prefix: "child_"

    schema "test_associations" do
      belongs_to(:parent, Parent, source: :association_id)
    end
  end

  test "can use inferred prefixes as a default for foreign_key_type" do
    {:ok, parent} =
      %Parent{}
      |> changeset()
      |> Repo.insert()

    assert "parent_" <> ksuid = parent.id
    assert {:ok, _ksuid} = Validator.is_valid?(ksuid)

    {:ok, child} =
      %Child{}
      |> changeset(%{parent_id: parent.id})
      |> Repo.insert()

    assert "child_" <> ksuid = child.id
    assert {:ok, _ksuid} = Validator.is_valid?(ksuid)

    assert "parent_" <> ksuid = child.parent_id
    assert {:ok, _ksuid} = Validator.is_valid?(ksuid)
  end
end
