defmodule EctoKsuid.CastTest do
  use EctoKsuid.DataCase

  test "cast/2 is valid for a nil" do
    value = nil
    options = Options.default()

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is valid for a string with valid format (no prefix)" do
    value = ksuid()
    options = Options.default()

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is valid for a string with valid format (string prefix)" do
    ksuid = ksuid()
    value = "runtime_#{ksuid}"
    options = Options.compile(prefix: "runtime_")

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is valid for a string with valid format (number prefix)" do
    ksuid = ksuid()
    value = "1234#{ksuid}"
    options = Options.compile(prefix: "1234")

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is valid for a string with valid format (emoji prefix)" do
    ksuid = ksuid()
    value = "❤️#{ksuid}"
    options = Options.compile(prefix: "❤️")

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is not valid for a string with an invalid format (missing prefix)" do
    ksuid = ksuid()
    value = ksuid
    options = Options.compile(prefix: "runtime_")

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a string with an invalid format (bad prefix)" do
    ksuid = ksuid()
    value = "runner_#{ksuid}"
    options = Options.compile(prefix: "runtime_")

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a string with an invalid format (ksuid too short)" do
    ksuid = ksuid()
    value = "runtime_#{String.slice(ksuid, 0, 26)}"
    options = Options.compile(prefix: "runtime_")

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a string with an invalid format (ksuid too long)" do
    ksuid = ksuid()
    value = "runtime_#{ksuid}a"
    options = Options.compile(prefix: "runtime_")

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a string with an invalid format (ksuid has incorrect characters)" do
    ksuid = ksuid()
    value = "runtime_#{String.slice(ksuid, 0, 26)}#"
    options = Options.compile(prefix: "runtime_")

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is valid when dumping prefix" do
    ksuid = ksuid()
    value = "runtime_#{ksuid}"
    options = Options.compile(prefix: "runtime_", dump_prefix: true)

    assert {:ok, ^value} = Type.cast(value, options)
  end

  test "cast/2 is invalid when dumping prefix and stored prefix is incorrect" do
    ksuid = ksuid()
    value = "invalid_#{ksuid}"
    options = Options.compile(prefix: "runtime_", dump_prefix: true)

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is invalid when dumping prefix and stored prefix is missing" do
    ksuid = ksuid()
    value = ksuid
    options = Options.compile(prefix: "runtime_", dump_prefix: true)

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a charlist" do
    value = ~c"charlist"
    options = Options.default()

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a map" do
    value = %{}
    options = Options.default()

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a list" do
    value = []
    options = Options.default()

    assert :error = Type.cast(value, options)
  end

  test "cast/2 is not valid for a struct" do
    value = DateTime.utc_now()
    options = Options.default()

    assert :error = Type.cast(value, options)
  end
end
