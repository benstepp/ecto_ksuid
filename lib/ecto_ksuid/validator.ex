defmodule Ecto.Ksuid.Validator do
  @moduledoc """
  Validates if a given value is a valid Ecto.Ksuid
  """

  alias Ecto.Ksuid.Options

  @doc """
  Validates a given Ecto.Ksuid.

  Will check that the value:

  * has the configured prefix
  * has the correct length
  * only includes the base62 alphabet

  ## Examples

      iex> Ecto.Ksuid.Validator.is_valid?("#{Ecto.Ksuid.generate()}", %Ecto.Ksuid.Options{prefix: ""})
      {:ok, valid_ksuid}

      iex> Ecto.Ksuid.Validator.is_valid?("prefix_#{Ecto.Ksuid.generate()}", %Ecto.Ksuid.Options{prefix: "prefix_"})
      {:ok, valid_ksuid}

      iex> Ecto.Ksuid.Validator.is_valid?(nil, %Ecto.Ksuid.Options{prefix: ""})
      :error

      iex> Ecto.Ksuid.Validator.is_valid?("wrong_#{Ecto.Ksuid.generate()}", %Ecto.Ksuid.Options{prefix: "prefix_"})
      :error

  """
  @spec is_valid?(String.t() | any(), Options.t()) :: {:ok, String.t()} | :error
  def is_valid?(value, options) when is_binary(value) do
    with :ok <- validate_prefix(value, options),
         ksuid <- Ecto.Ksuid.remove_prefix(value, options),
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

      iex> Ecto.Ksuid.Validator.is_valid?("#{Ecto.Ksuid.generate()}")
      {:ok, valid_ksuid}

      iex> Ecto.Ksuid.Validator.is_valid?(nil)
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
