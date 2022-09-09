defmodule Ecto.Ksuid.ValidatorTest do
  use Ecto.Ksuid.DataCase

  alias Ecto.Ksuid.Validator

  test "is_valid/2 returns :ok for a valid ksuid without a prefix" do
    value = ksuid()
    options = Options.default()

    assert {:ok, ^value} = Validator.is_valid?(value, options)
  end

  test "is_valid/2 returns :ok for a valid ksuid with a prefix" do
    value = "prefix_#{ksuid()}"
    options = Options.compile(prefix: "prefix_")

    assert {:ok, ^value} = Validator.is_valid?(value, options)
  end

  test "is_valid/2 returns :error for an integer" do
    value = 1
    options = Options.default()

    assert :error = Validator.is_valid?(value, options)
  end

  test "is_valid/2 returns :error for an map" do
    value = %{}
    options = Options.default()

    assert :error = Validator.is_valid?(value, options)
  end

  test "is_valid?/1 returns :ok for valid ksuid" do
    value = ksuid()
    assert {:ok, ^value} = Validator.is_valid?(value)
  end

  test "is_valid?/1 returns :error for nil" do
    assert :error = Validator.is_valid?(nil)
  end

  test "is_valid?/1 returns :error for an integer" do
    assert :error = Validator.is_valid?(1)
  end

  test "is_valid?/1 returns :error for a map" do
    assert :error = Validator.is_valid?(%{})
  end

  test "is_valid?/1 returns :error for a string that is too long" do
    value = ksuid() <> ksuid()
    assert :error = Validator.is_valid?(value)
  end
end
