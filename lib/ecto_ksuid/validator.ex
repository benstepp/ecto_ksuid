defmodule Ecto.Ksuid.Validator do
  @moduledoc """
  Validates if a given value is valid
  """

  alias Ecto.Ksuid.Options

  @spec is_valid?(String.t() | any(), Options.t()) :: {:ok, String.t()} | :error
  def is_valid?(value, options) do
    with :ok <- validate_prefix(value, options),
         ksuid <- Ecto.Ksuid.remove_prefix(value, options),
         {:ok, _ksuid} <- is_valid?(ksuid),
         do: {:ok, value}
  end

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
