ExUnit.start()

{:ok, _pid} = Ecto.Adapters.Postgres.ensure_all_started(EctoKsuid.TestRepo, :temporary)
_ = Ecto.Adapters.Postgres.storage_down(EctoKsuid.TestRepo.config())
:ok = Ecto.Adapters.Postgres.storage_up(EctoKsuid.TestRepo.config())

{:ok, _pid} = EctoKsuid.TestRepo.start_link()

:ok = Ecto.Migrator.up(EctoKsuid.TestRepo, 0, EctoKsuid.TestMigration, log: false)
Ecto.Adapters.SQL.Sandbox.mode(EctoKsuid.TestRepo, :manual)

Logger.configure(level: :info)
# Ecto.Adapters.Postgres.structure_dump("./test/support", EctoKsuid.TestRepo.config())
