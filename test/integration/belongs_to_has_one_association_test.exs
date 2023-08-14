defmodule EctoKsuid.BelongsToHasOneAssociationTest do
  use EctoKsuid.DataCase, async: true

  defmodule Parent do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, autogenerate: true}

    schema "test_schemas" do
      has_one(:child, EctoKsuid.BelongsToHasOneAssociationTest.Child,
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

  test "belongs to/has_one association works both ways" do
    {:ok, parent} =
      %Parent{}
      |> changeset()
      |> Repo.insert()

    {:ok, child} =
      %Child{}
      |> changeset(%{association_id: parent.id})
      |> Repo.insert()

    assert child ==
             parent
             |> Ecto.assoc(:child)
             |> Repo.one()

    assert parent ==
             child
             |> Ecto.assoc(:parent)
             |> Repo.one()

    assert child ==
             Child
             |> Ecto.Query.where([c], c.association_id == ^parent.id)
             |> Repo.one()

    assert parent ==
             Parent
             |> Ecto.Query.where([p], p.id == ^child.association_id)
             |> Repo.one()
  end

  defmodule ParentWithPrefix do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, prefix: "parent_", autogenerate: true}

    schema "test_schemas" do
      has_one(:child, EctoKsuid.BelongsToHasOneAssociationTest.ChildWithPrefix,
        foreign_key: :association_id
      )
    end
  end

  defmodule ChildWithPrefix do
    use Ecto.Schema

    @primary_key {:id, EctoKsuid, prefix: "child_", autogenerate: true}

    schema "test_associations" do
      belongs_to(:parent, ParentWithPrefix,
        foreign_key: :association_id,
        type: EctoKsuid
      )
    end
  end

  test "belongs_to/has_one association works both ways with prefixes" do
    {:ok, parent} =
      %ParentWithPrefix{}
      |> changeset()
      |> Repo.insert()

    {:ok, child} =
      %ChildWithPrefix{}
      |> changeset(%{association_id: parent.id})
      |> Repo.insert()

    assert child ==
             parent
             |> Ecto.assoc(:child)
             |> Repo.one()

    assert parent ==
             child
             |> Ecto.assoc(:parent)
             |> Repo.one()

    assert child ==
             ChildWithPrefix
             |> Ecto.Query.where([c], c.association_id == ^parent.id)
             |> Repo.one()

    assert parent ==
             ParentWithPrefix
             |> Ecto.Query.where([p], p.id == ^child.association_id)
             |> Repo.one()
  end
end
