defmodule Ecto.Ksuid.TestMigration do
  use Ecto.Migration

  def change() do
    create table(:test_schemas, primary_key: false) do
      add(:id, :char, size: 27, primary_key: true)
    end
  end
end
