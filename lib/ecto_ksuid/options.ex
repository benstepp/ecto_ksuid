defmodule Ecto.Ksuid.Options do
  defstruct [
    :prefix
  ]

  @type t() :: %__MODULE__{
          prefix: String.t()
        }

  @spec compile(keyword()) :: t()
  def compile(opts \\ []) do
    %__MODULE__{
      prefix: prefix(opts)
    }
  end

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
        Ecto.Ksuid types must have a :prefix option of a string, found #{inspect(invalid)}.

        For example:

          schema "users" do
            field :id, Ecto.Ksuid, prefix: "users_"
            # ...
          end

        or

          @primary_key {:id, Ecto.Ksuid, prefix: "test_"}
          schema "users" do
            # ...
          end
        """

      :error ->
        ""
    end
  end
end
