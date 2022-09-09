defmodule Ecto.Ksuid.OptionsTest do
  use Ecto.Ksuid.DataCase

  test "default/0 uses an empty prefix" do
    assert %Options{prefix: ""} = Options.default()
  end

  test "compile/1 uses the passed prefix" do
    assert %Options{prefix: "test_"} = Options.compile(prefix: "test_")
  end

  test "compile/1 uses an empty prefix when none passed" do
    assert %Options{prefix: ""} = Options.compile([])
  end

  test "compile/1 uses an empty prefix when no options passed" do
    assert %Options{prefix: ""} = Options.compile()
  end

  test "compile/1 raises when passed nil prefix" do
    assert_raise ArgumentError, fn ->
      Options.compile(prefix: nil)
    end
  end

  test "compile/1 raises when passed atom prefix" do
    assert_raise ArgumentError, fn ->
      Options.compile(prefix: :test)
    end
  end

  test "compile/1 raises when passed tuple prefix" do
    assert_raise ArgumentError, fn ->
      Options.compile(prefix: {"test_"})
    end
  end

  test "compile/1 raises when passed integer prefix" do
    assert_raise ArgumentError, fn ->
      Options.compile(prefix: 123)
    end
  end
end
