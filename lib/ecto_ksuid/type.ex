defmodule Ecto.Ksuid.Type do
  @moduledoc """
  Contains callbacks for an `Ecto.ParameterizedType`
  """

  alias Ecto.Ksuid.Options
  alias Ecto.Ksuid.Validator

  @spec init(keyword()) :: Options.t()
  def init(opts) do
    Options.compile(opts)
  end

  @spec type(Options.t()) :: :string
  def type(_options), do: :string

  @spec cast(String.t() | nil | any(), Options.t()) ::
          {:ok, Ecto.Ksuid.runtime_ksuid()} | {:ok, nil} | :error
  def cast(value, options) when is_binary(value) do
    Validator.is_valid?(value, options)
  end

  def cast(value, _options) when is_nil(value) do
    {:ok, value}
  end

  def cast(_value, _options) do
    :error
  end

  @spec dump(Ecto.Ksuid.runtime_ksuid() | nil | any(), function(), Options.t()) ::
          {:ok, Ecto.Ksuid.database_ksuid()} | {:ok}
  def dump(value, _dumper, options) when is_binary(value) do
    value
    |> Ecto.Ksuid.remove_prefix(options)
    |> Validator.is_valid?()
  end

  def dump(value, _dumper, _options) when is_nil(value) do
    {:ok, value}
  end

  def dump(_value, _dumper, _options) do
    :error
  end

  @spec load(Ecto.Ksuid.database_ksuid() | nil | any(), function(), Options.t()) ::
          {:ok, Ecto.Ksuid.runtime_ksuid()} | {:ok}
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

  @spec autogenerate(Options.t()) :: Ecto.Ksuid.runtime_ksuid()
  def autogenerate(options) do
    "#{options.prefix}#{Ecto.Ksuid.generate()}"
  end
end
