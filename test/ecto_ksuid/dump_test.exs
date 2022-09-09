defmodule Ecto.Ksuid.DumpTest do
  use Ecto.Ksuid.DataCase

  def dumper(), do: nil
  @dumper &__MODULE__.dumper/0

  test "dump/3 removes the runtime prefix" do
    ksuid = ksuid()
    id = "runtime_#{ksuid}"
    options = Options.compile(prefix: "runtime_")

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes prefix without underscore" do
    ksuid = ksuid()
    id = "test#{ksuid}"
    options = Options.compile(prefix: "test")

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes number prefixes" do
    ksuid = ksuid()
    id = "123#{ksuid}"
    options = Options.compile(prefix: "123")

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes emoji prefixes" do
    ksuid = ksuid()
    id = "❤️#{ksuid}"
    options = Options.compile(prefix: "❤️")

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes nothing when no prefix configured" do
    ksuid = ksuid()
    options = Options.default()

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end

  test "dump/3 removes nothing when empty string prefix configured" do
    ksuid = ksuid()
    options = Options.compile(prefix: "")

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end
end
