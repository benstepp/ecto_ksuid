defmodule EctoKsuid.DumpTest do
  use EctoKsuid.DataCase

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

  test "dump/3 keeps a string prefix with dump_prefix: true" do
    ksuid = ksuid()
    id = "test_#{ksuid}"
    options = Options.compile(prefix: "test_", dump_prefix: true)

    assert {:ok, ^id} = Type.dump(id, @dumper, options)
  end

  test "dump/3 keeps a string prefix without underscore with dump_prefix: true" do
    ksuid = ksuid()
    id = "test#{ksuid}"
    options = Options.compile(prefix: "test", dump_prefix: true)

    assert {:ok, ^id} = Type.dump(id, @dumper, options)
  end

  test "dump/3 keeps a number prefix with dump_prefix: true" do
    ksuid = ksuid()
    id = "1#{ksuid}"
    options = Options.compile(prefix: "1", dump_prefix: true)

    assert {:ok, ^id} = Type.dump(id, @dumper, options)
  end

  test "dump/3 keeps an emoji prefix with dump_prefix: true" do
    ksuid = ksuid()
    id = "❤️#{ksuid}"
    options = Options.compile(prefix: "❤️", dump_prefix: true)

    assert {:ok, ^id} = Type.dump(id, @dumper, options)
  end

  test "dump/3 removes nothing when no prefix with dump_prefix: true" do
    ksuid = ksuid()
    options = Options.compile(prefix: "", dump_prefix: true)

    assert {:ok, ^ksuid} = Type.dump(ksuid, @dumper, options)
  end

  test "dump/3 errors when passed an invalid value" do
    value = {}
    options = Options.default()

    assert :error = Type.dump(value, @dumper, options)
  end
end
