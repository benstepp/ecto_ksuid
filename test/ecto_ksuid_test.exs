defmodule EctoKsuidTest do
  use EctoKsuid.DataCase

  test "column/0 returns char(27)" do
    assert :"char(27)" = EctoKsuid.column()
  end

  test "remove_prefix/0 removes prefixes" do
    ksuid = EctoKsuid.generate()

    assert ksuid == EctoKsuid.remove_prefix("prefix_#{ksuid}")
    assert ksuid == EctoKsuid.remove_prefix("nounderscore#{ksuid}")
    assert ksuid == EctoKsuid.remove_prefix("any string ty#{ksuid}")
  end
end
