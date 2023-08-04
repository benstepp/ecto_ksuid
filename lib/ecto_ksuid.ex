defmodule EctoKsuid do
  @moduledoc """
  Custom Ecto type to support ksuids
  """

  use Ecto.ParameterizedType

  alias EctoKsuid.Options
  alias EctoKsuid.Type

  @typedoc """
  An `EctoKsuid` is a base62 encoded string. That may or may not include an
  optional configure prefix.
  """
  @type t() :: String.t()

  @typedoc """
  A runtime_ksuid is the value of the EctoKsuid in the elixir application.

  It contains the configured prefix and the ksuid stored in the database.
  """
  @type runtime_ksuid() :: t()

  @typedoc """
  A database_ksuid is the value of the EctoKsuid in the database.

  It contains just the ksuid without the configured prefix.
  """
  @type database_ksuid() :: t()

  @impl Ecto.ParameterizedType
  defdelegate init(opts), to: Type

  @impl Ecto.ParameterizedType
  defdelegate type(options), to: Type

  @impl Ecto.ParameterizedType
  defdelegate cast(value, options), to: Type

  @impl Ecto.ParameterizedType
  defdelegate dump(value, dumper, options), to: Type

  @impl Ecto.ParameterizedType
  defdelegate load(value, loader, options), to: Type

  @impl Ecto.ParameterizedType
  defdelegate autogenerate(options), to: Type

  @doc """
  Removes the configured prefix from an EctoKsuid.

  This can be used to get the raw ksuid without the runtime prefix.

  ## Examples

      iex> EctoKsuid.remove_prefix("prefix_2EXLuF3dU8v4L4JLInQXNWpjKE0", %EctoKsuid.Options{prefix: "prefix_"})
      "2EXLuF3dU8v4L4JLInQXNWpjKE0"

      iex> EctoKsuid.remove_prefix("2EXLuF3dU8v4L4JLInQXNWpjKE0", %EctoKsuid.Options{prefix: ""})
      "2EXLuF3dU8v4L4JLInQXNWpjKE0"

  """
  @spec remove_prefix(String.t(), Options.t()) :: database_ksuid()
  def remove_prefix(value, %Options{} = options) when is_binary(value) do
    case options.prefix do
      "" ->
        value

      prefix ->
        String.replace_leading(value, prefix, "")
    end
  end

  @doc """
  Generates a new ksuid.

  This function returns a 20 byte Ksuid which has 4 bytes as timestamp and 16
  bytes of crypto string bytes.

  This function delegates to the `Ksuid` library and is functionally similar to
  `Ecto.UUID.generate/0`

  ## Examples

      iex> EctoKsuid.generate()
      "#{Ksuid.generate()}"
  """
  @spec generate() :: t()
  def generate() do
    Ksuid.generate()
  end

  @doc """
  Returns the primitive migration type for an EctoKsuid.

  This can be used in your migrations, so you don't have to rememeber exactly
  how large a ksuid is.

  ## Examples

  ### In an ecto migration:

  ```elixir
  def change() do
    create table(:table_name, primary_key: false) do
      add(:id, EctoKsuid.column(), primary_key: true)
    end
  end
  ```

  ### In your repo config

  ```elixir
  config :my_app, MyApp.Repo,
    migration_primary_key: [name: :id, type: :"char(27)"],
    migration_foreign_key: [name: :id, type: :"char(27)"]
  ```
  """
  @spec column() :: :"char(27)"
  def column() do
    :"char(27)"
  end
end
