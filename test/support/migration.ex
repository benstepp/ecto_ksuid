defmodule EctoKsuid.TestMigration do
  @moduledoc false

  use Ecto.Migration

  def change() do
    create table(:test_schemas, primary_key: false) do
      add(:id, :"char(27)", primary_key: true)
      add(:public_id, :"char(27)")
    end

    create table(:test_associations, primary_key: false) do
      add(:id, :char, size: 27, primary_key: true)
      add(:public_id, :"char(27)")
      add(:association_id, references(:test_schemas))
    end
  end
end
