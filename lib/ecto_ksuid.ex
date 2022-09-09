defmodule Ecto.Ksuid do
  @moduledoc """
  Documentation for `Ecto.Ksuid`.
  """

  use Ecto.ParameterizedType

  @behaviour Ecto.ParameterizedType

  @impl Ecto.ParamterizedType
  def init(opts) do
    Ecto.Ksuid.Options.compile(opts)
  end

  @impl Ecto.ParamterizedType
  def type(_options), do: :string

  @impl Ecto.ParamterizedType
  def cast(value, options) when is_binary(value) do
    Ecto.Ksuid.Validator.is_valid?(value, options)
  end

  def cast(value, _options) when is_nil(value) do
    {:ok, value}
  end

  def cast(_value, _options) do
    :error
  end

  @impl Ecto.ParamterizedType
  def dump(value, _loader, options) when is_binary(value) do
    value
    |> remove_prefix(options)
    |> Ecto.Ksuid.Validator.is_valid?()
  end

  def dump(value, _loader, _options) when is_nil(value) do
    {:ok, value}
  end

  def dump(_value, _loader, _options) do
    :error
  end

  @impl Ecto.ParamterizedType
  def load(value, _loader, options) when is_binary(value) do
    {:ok, "#{options.prefix}#{value}"}
  end

  def load(value, _loader, _options) when is_nil(value) do
    {:ok, value}
  end

  @impl Ecto.ParamterizedType
  def equal?(a, b, _options) do
    a == b
  end

  @impl Ecto.ParamterizedType
  def autogenerate(options) do
    "#{options.prefix}#{Ksuid.generate()}"
  end

  def remove_prefix(value, options) do
    case options.prefix do
      "" ->
        value

      prefix ->
        String.replace_leading(value, prefix, "")
    end
  end
end
