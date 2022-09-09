defmodule Ecto.Ksuid do
  @moduledoc """
  Documentation for `Ecto.Ksuid`.
  """

  use Ecto.ParameterizedType

  @impl Ecto.ParameterizedType
  def init(opts) do
    Ecto.Ksuid.Options.compile(opts)
  end

  @impl Ecto.ParameterizedType
  def type(_options), do: :string

  @impl Ecto.ParameterizedType
  def cast(value, options) when is_binary(value) do
    Ecto.Ksuid.Validator.is_valid?(value, options)
  end

  def cast(value, _options) when is_nil(value) do
    {:ok, value}
  end

  def cast(_value, _options) do
    :error
  end

  @impl Ecto.ParameterizedType
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

  @impl Ecto.ParameterizedType
  def load(value, _loader, options) when is_binary(value) do
    case Ecto.Ksuid.Validator.is_valid?(value) do
      {:ok, value} ->
        {:ok, "#{options.prefix}#{value}"}

      :error ->
        :error
    end
  end

  def load(value, _loader, _options) when is_nil(value) do
    {:ok, value}
  end

  def load(_value, _loader, _options) do
    :error
  end

  @impl Ecto.ParameterizedType
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
