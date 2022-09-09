defmodule Ecto.KsuidTest do
  use Ecto.Ksuid.DataCase, async: true

  test "never errors lol" do
    1..1000
    |> Enum.each(fn _ ->
      %TestSchema{}
      |> TestSchema.changeset()
      |> TestRepo.insert!()
    end)
  end
end
