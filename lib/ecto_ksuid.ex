defmodule Ecto.Ksuid do
  @moduledoc """
  Custom Ecto type to support ksuids
  """

  use Ecto.ParameterizedType

  alias Ecto.Ksuid.Options
  alias Ecto.Ksuid.Type

  @typedoc """
  An `Ecto.Ksuid` is a base62 encoded string. That may or may not include an
  optional configure prefix.
  """
  @type t() :: String.t()

  @typedoc """
  A runtime_ksuid is the value of the Ecto.Ksuid in the elixir application.

  It contains the configured prefix and the ksuid stored in the database.
  """
  @type runtime_ksuid() :: t()

  @typedoc """
  A database_ksuid is the value of the Ecto.Ksuid in the database.

  It contains just the ksuid without the configured prefix.
  """
  @type database_ksuid() :: t()

  @impl Ecto.ParameterizedType
  def init(opts), do: Type.init(opts)

  @impl Ecto.ParameterizedType
  def type(options), do: Type.type(options)

  @impl Ecto.ParameterizedType
  def cast(value, options), do: Type.cast(value, options)

  @impl Ecto.ParameterizedType
  def dump(value, dumper, options), do: Type.dump(value, dumper, options)

  @impl Ecto.ParameterizedType
  def load(value, loader, options), do: Type.load(value, loader, options)

  @impl Ecto.ParameterizedType
  def autogenerate(options), do: Type.autogenerate(options)

  @doc """
  Removes the configured prefix from an Ecto.Ksuid.

  This can be used to get the raw ksuid without the runtime prefix.

  ## Examples

      iex> Ecto.Ksuid.remove_prefix("prefix_2EXLuF3dU8v4L4JLInQXNWpjKE0", %Ecto.Ksuid.Options{prefix: "prefix_"})
      "2EXLuF3dU8v4L4JLInQXNWpjKE0"

      iex> Ecto.Ksuid.remove_prefix("2EXLuF3dU8v4L4JLInQXNWpjKE0", %Ecto.Ksuid.Options{prefix: ""})
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

      iex> Ecto.Ksuid.generate()
      "#{Ksuid.generate()}"
  """
  @spec generate() :: t()
  def generate() do
    Ksuid.generate()
  end

  @doc """
  Returns the primitive migration type for an Ecto.Ksuid.

  This can be used in your migrations, so you don't have to rememeber exactly
  how large a ksuid is.

  ## Examples

  ### In an ecto migration:

  ```elixir
  def change() do
    create table(:table_name, primary_key: false) do
      add(:id, Ecto.Ksuid.column(), primary_key: true)
    end
  end
  ```

  ### In your repo config

  ```elixir
  config :my_app, MyApp.Repo,
    migration_primary_key: [name: :id, type: Ecto.Ksuid.column()],
    migration_foreign_key: [name: :id, type: Ecto.Ksuid.column()]
  ```
  """
  @spec column() :: :"char(27)"
  def column() do
    :"char(27)"
  end
end
