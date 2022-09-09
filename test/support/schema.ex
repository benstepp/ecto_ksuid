defmodule Ecto.Ksuid.RawTestSchema do
  @moduledoc """
  Raw access to the strings stored in the database
  """

  use Ecto.Schema

  @primary_key {:id, :string, []}
  schema "test_schemas" do
    field(:public_id, :string)
  end
end
