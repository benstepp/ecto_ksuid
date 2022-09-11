defmodule EctoKsuid.Validator do
  @moduledoc """
  Validates if a given value is a valid EctoKsuid
  """

  alias EctoKsuid.Options

  @doc """
  Validates a given EctoKsuid.

  Will check that the value:

  * has the configured prefix
  * has the correct length
  * only includes the base62 alphabet

  ## Examples

      iex> EctoKsuid.Validator.is_valid?("#{EctoKsuid.generate()}", %EctoKsuid.Options{prefix: ""})
      {:ok, valid_ksuid}

      iex> EctoKsuid.Validator.is_valid?("prefix_#{EctoKsuid.generate()}", %EctoKsuid.Options{prefix: "prefix_"})
      {:ok, valid_ksuid}

      iex> EctoKsuid.Validator.is_valid?(nil, %EctoKsuid.Options{prefix: ""})
      :error

      iex> EctoKsuid.Validator.is_valid?("wrong_#{EctoKsuid.generate()}", %EctoKsuid.Options{prefix: "prefix_"})
      :error

  """
  @spec is_valid?(String.t() | any(), Options.t()) :: {:ok, String.t()} | :error
  def is_valid?(value, options) when is_binary(value) do
    with :ok <- validate_prefix(value, options),
         ksuid <- EctoKsuid.remove_prefix(value, options),
         {:ok, _ksuid} <- is_valid?(ksuid),
         do: {:ok, value}
  end

  def is_valid?(_value, _options) do
    :error
  end

  @doc """
  Validates a given ksuid.

  Will check that the value:

  * has the correct length
  * only includes the base62 alphabet

  ## Examples

      iex> EctoKsuid.Validator.is_valid?("#{EctoKsuid.generate()}")
      {:ok, valid_ksuid}

      iex> EctoKsuid.Validator.is_valid?(nil)
      :error

  """
  @spec is_valid?(String.t() | any()) :: {:ok, String.t()} | :error
  def is_valid?(value) when is_binary(value) do
    with :ok <- validate_length(value),
         :ok <- validate_format(value),
         do: {:ok, value}
  end

  def is_valid?(_value) do
    :error
  end

  defp validate_prefix(value, options) do
    case String.starts_with?(value, options.prefix) do
      true -> :ok
      false -> :error
    end
  end

  defp validate_length(value) do
    case String.length(value) == 27 do
      true -> :ok
      false -> :error
    end
  end

  @base62 ~r/[1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]{27}/
  defp validate_format(value) do
    case String.match?(value, @base62) do
      true -> :ok
      false -> :error
    end
  end
end
