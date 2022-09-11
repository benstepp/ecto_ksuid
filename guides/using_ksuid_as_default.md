# Using Ksuid as the Default

If you are starting a new project with ecto, it may be desirable to use ksuids
as the default in your system. This guide will guide you through the steps needed.

## Configuring Migrations

This is very similar to configuring your migrations to use a `:binary_id` as a
default. See also the **Repo Configuration** section of `Ecto.Migration`.

1. Configure your Repo.

   ```elixir
   # config/config.exs
   config :my_app, MyApp.Repo,
     migration_primary_key: [name: :id, type: EctoKsuid.column()],
     migration_foreign_key: [name: :id, type: EctoKsuid.column()]
   ```

2. Create migrations as you normally would.

   ```elixir
   # priv/repo/migrations/create_posts.exs
   defmodule MyApp.Repo.Migrations.CreatePosts do
     use Ecto.Migration

     def change() do
       create table(:posts) do
         add :title, :string
       end

       create table(:comments) do
         add :post_id, references(:posts)
       end
     end
   end
   ```

Now, any migrations that will add a `:primary_key` of `:id` with the `EctoKsuid`
type. Additionally, any references will use the `EctoKsuid` type.

## Configuring Schemas

This is very similar to configuring your application to use a `:binary_id` as
default. See also the **Schema Attributes** section of `Ecto.Schema`.

1. Define a module to be use as a base

   ```elixir
   # lib/my_app/schema.ex
   defmodule MyApp.Schema do
     defmacro __using__(_) do
       quote do
         use Ecto.Schema

         @primary_key {:id, EctoKsuid, autogenerate: true}
         @foreign_key_type EctoKsuid
       end
     end
   end
   ```

2. Now use `MyApp.Schema` instead of `Ecto.Schema` to define new schemas in
   your application.

   ```elixir
   # lib/my_app/comment.ex
   defmodule MyApp.Comment do
     use MyApp.Schema

     schema "comments" do
       belongs_to :post, MyApp.Post
     end
   end
   ```

Now any schemas using `MyApp.Schema` will get the `:id` field with the type of
`EctoKsuid` as the primary key.

The `belongs_to` association on `MyApp.Comment` will also define a `:post_id`
field with the `EctoKsuid` type that references the `:id` field of the
`MyApp.Post`
