defmodule Ecto.Ksuid.DumpTest do
  use Ecto.Ksuid.DataCase

  def dumper(), do: nil
  @dumper &__MODULE__.dumper/0

  test "dump/3 removes the runtime prefix" do
    ksuid = ksuid()
    id = "runtime_#{ksuid}"
    options = %{prefix: "runtime_"}

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes prefix without underscore" do
    ksuid = ksuid()
    id = "test#{ksuid}"
    options = %{prefix: "test"}

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes number prefixes" do
    ksuid = ksuid()
    id = "123#{ksuid}"
    options = %{prefix: "123"}

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes emoji prefixes" do
    ksuid = ksuid()
    id = "❤️#{ksuid}"
    options = %{prefix: "❤️"}

    assert {:ok, ^ksuid} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes nothing when no prefix configured" do
    ksuid = ksuid()
    options = %{}

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end

  test "dump/3 removes nothing when nil prefix configured" do
    ksuid = ksuid()
    options = %{prefix: nil}

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end

  test "dump/3 removes nothing when empty string prefix configured" do
    ksuid = ksuid()
    options = %{prefix: ""}

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end
end
