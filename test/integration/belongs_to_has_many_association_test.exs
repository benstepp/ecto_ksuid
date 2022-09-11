defmodule EctoKsuid.BelongsToHasManyAssociationTest do
  use EctoKsuid.DataCase, async: true

  defmodule Parent do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, autogenerate: true}

    schema "test_schemas" do
      has_many(:children, EctoKsuid.BelongsToHasManyAssociationTest.Child,
        foreign_key: :association_id
      )
    end
  end

  defmodule Child do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, autogenerate: true}

    schema "test_associations" do
      belongs_to(:parent, Parent, foreign_key: :association_id, type: EctoKsuid)
    end
  end

  test "belongs to/has_many association works both ways" do
    {:ok, parent} =
      %Parent{}
      |> changeset()
      |> Repo.insert()

    {:ok, first_child} =
      %Child{}
      |> changeset(%{association_id: parent.id})
      |> Repo.insert()

    {:ok, second_child} =
      %Child{}
      |> changeset(%{association_id: parent.id})
      |> Repo.insert()

    assert children =
             parent
             |> Ecto.assoc(:children)
             |> Repo.all()

    assert first_child in children
    assert second_child in children

    assert assoc_parent =
             first_child
             |> Ecto.assoc(:parent)
             |> Repo.one()

    assert assoc_parent == parent

    assert assoc_parent =
             second_child
             |> Ecto.assoc(:parent)
             |> Repo.one()

    assert assoc_parent == parent
  end
end
