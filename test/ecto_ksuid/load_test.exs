defmodule Ecto.Ksuid.LoadTest do
  use Ecto.Ksuid.DataCase

  def loader(), do: nil
  @loader &__MODULE__.loader/0

  test "load/3 can load a nil value without a prefix" do
    value = nil
    options = Options.default()

    assert {:ok, ^value} = Type.load(value, @loader, options)
  end

  test "load/3 can load a nil value with a prefix" do
    value = nil
    options = Options.compile(prefix: "test_")

    assert {:ok, ^value} = Type.load(value, @loader, options)
  end

  test "load/3 returns without prefix if not configured" do
    value = ksuid()
    options = Options.default()

    assert {:ok, ^value} = Type.load(value, @loader, options)
  end

  test "load/3 adds the runtime prefix" do
    value = ksuid()
    options = Options.compile(prefix: "test_")

    assert {:ok, result} = Type.load(value, @loader, options)
    assert result == "test_#{value}"
  end

  test "load/3 errors on invalid ksuid" do
    value = String.slice(ksuid(), 0, 25)
    options = Options.compile(prefix: "test_")

    assert :error = Type.load(value, @loader, options)
  end

  test "load/3 errors on integer types" do
    value = 123
    options = Options.compile(prefix: "test_")

    assert :error = Type.load(value, @loader, options)
  end

  test "load/3 errors on datetime types" do
    value = DateTime.utc_now()
    options = Options.compile(prefix: "test_")

    assert :error = Type.load(value, @loader, options)
  end
end
