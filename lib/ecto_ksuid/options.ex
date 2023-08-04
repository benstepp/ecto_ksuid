defmodule EctoKsuid.Options do
  @moduledoc """
  Struct containing validated options

  This is used internally to generate the options used by the
  callbacks of the `Ecto.ParameterizedType` behaviour.
  """

  defstruct [
    :prefix,
    :config
  ]

  @type t() :: %__MODULE__{
          prefix: String.t() | :inferred,
          config: map()
        }

  @doc """
  Compiles EctoKsuid.Options given a keyword list of opts
  """
  @spec compile(keyword()) :: t()
  def compile(opts \\ [])

  def compile(opts) when is_list(opts) do
    %__MODULE__{
      prefix: option_prefix(opts),
      config: Map.new(opts)
    }
  end

  @doc """
  Returns the default options for EctoKsuid
  """
  @spec default() :: t()
  def default() do
    compile()
  end

  defp option_prefix(opts) do
    opts
    |> Keyword.fetch(:prefix)
    |> case do
      {:ok, prefix} when is_binary(prefix) ->
        prefix

      {:ok, :inferred} ->
        :inferred

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

  @doc """
  Returns the prefix for a given set of options
  """
  @spec prefix(options :: t()) :: String.t()
  def prefix(%__MODULE__{prefix: :inferred, config: config}) do
    inferred_prefix(config)
  end

  def prefix(%__MODULE__{prefix: prefix}) do
    prefix
  end

  defp inferred_prefix(%{schema: schema, field: field}) when is_atom(schema) and is_atom(field) do
    inferred_prefix(schema.__schema__(:association, field))
  end

  defp inferred_prefix(%Ecto.Association.BelongsTo{related: related, related_key: related_key}) do
    case related.__schema__(:type, related_key) do
      {:parameterized, EctoKsuid, %__MODULE__{prefix: prefix}} ->
        prefix

      _ ->
        ""
    end
  end

  defp inferred_prefix(_), do: ""
end
