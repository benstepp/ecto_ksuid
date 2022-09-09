defmodule Ecto.KsuidTest do
  use Ecto.Ksuid.DataCase, async: true

  test "greets the world" do
    assert {:ok, r} =
             %TestSchema{}
             |> TestSchema.changeset()
             |> TestRepo.insert()

    assert true
  end
end
