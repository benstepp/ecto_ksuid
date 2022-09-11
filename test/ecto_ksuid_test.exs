defmodule EctoKsuidTest do
  use EctoKsuid.DataCase

  test "column/0 returns char(27)" do
    assert :"char(27)" = EctoKsuid.column()
  end
end
