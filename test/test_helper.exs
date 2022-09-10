ExUnit.start()

{:ok, _pid} = Ecto.Adapters.Postgres.ensure_all_started(Ecto.Ksuid.TestRepo, :temporary)
_ = Ecto.Adapters.Postgres.storage_down(Ecto.Ksuid.TestRepo.config())
:ok = Ecto.Adapters.Postgres.storage_up(Ecto.Ksuid.TestRepo.config())

{:ok, _pid} = Ecto.Ksuid.TestRepo.start_link()

:ok = Ecto.Migrator.up(Ecto.Ksuid.TestRepo, 0, Ecto.Ksuid.TestMigration, log: false)
Ecto.Adapters.SQL.Sandbox.mode(Ecto.Ksuid.TestRepo, :manual)

Logger.configure(level: :info)
# Ecto.Adapters.Postgres.structure_dump("./test/support", Ecto.Ksuid.TestRepo.config())
