defmodule Ecto.KsuidTest do
  use Ecto.Ksuid.DataCase

  test "column/0 returns char(27)" do
    assert :"char(27)" = Ecto.Ksuid.column()
  end
end
