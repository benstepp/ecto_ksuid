defmodule Ecto.Ksuid.BelongsToHasOneAssociationTest do
  use Ecto.Ksuid.DataCase, async: true

  defmodule Parent do
    use Ecto.Schema

    @primary_key {:id, Ecto.Ksuid, autogenerate: true}

    schema "test_schemas" do
      has_one(:child, Ecto.Ksuid.BelongsToHasOneAssociationTest.Child,
        foreign_key: :association_id
      )
    end
  end

  defmodule Child do
    use Ecto.Schema

    @primary_key {:id, Ecto.Ksuid, autogenerate: true}

    schema "test_associations" do
      belongs_to(:parent, Parent, foreign_key: :association_id, type: Ecto.Ksuid)
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

    assert assoc_child =
             parent
             |> Ecto.assoc(:child)
             |> Repo.one()

    assert assoc_child == child

    assert assoc_parent =
             child
             |> Ecto.assoc(:parent)
             |> Repo.one()

    assert assoc_parent == parent
  end
end
