defmodule EctoKsuid.Options do
  @moduledoc """
  Struct containing validated options

  This is used internally to generate the options used by the
  callbacks of the `Ecto.ParameterizedType` behaviour.
  """

  defstruct [
    :prefix
  ]

  @type t() :: %__MODULE__{
          prefix: String.t()
        }

  @doc """
  Compiles EctoKsuid.Options given a keyword list of opts
  """
  @spec compile(keyword()) :: t()
  def compile(opts \\ [])

  def compile(opts) when is_list(opts) do
    %__MODULE__{
      prefix: prefix(opts)
    }
  end

  @doc """
  Returns the default options for EctoKsuid
  """
  @spec default() :: t()
  def default() do
    compile()
  end

  defp prefix(opts) do
    opts
    |> Keyword.fetch(:prefix)
    |> case do
      {:ok, prefix} when is_binary(prefix) ->
        prefix

      {:ok, invalid} ->
        raise ArgumentError, """
        EctoKsuid types must have a :prefix option of a string, found #{inspect(invalid)}.

        For example:

          schema "users" do
            field :id, EctoKsuid, prefix: "users_"
            # ...
          end

        or

          @primary_key {:id, EctoKsuid, prefix: "test_"}
          schema "users" do
            # ...
          end
        """

      :error ->
        ""
    end
  end
end
