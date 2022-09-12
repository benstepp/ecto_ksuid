# ecto_ksuid

![License MIT](https://img.shields.io/badge/license-MIT-brightgreen 'License MIT')
![Build Status](https://github.com/benstepp/ecto_ksuid/actions/workflows/ci.yml/badge.svg)

`EctoKsuid` allows seamless usage of
[ksuids](https://github.com/segmentio/ksuid) with `:ecto` in your application.
To get a better idea of what ksuids are, and how they came to be I highly
recommend reading [A breif History of the
UUID](https://segment.com/blog/a-brief-history-of-the-uuid/)

> [Ksuid] borrows core ideas from the ubiquitous UUID standard, adding time-based
> ordering and more friendly representation formats.

Additionally, `EctoKsuid` allows easy addition of a `:prefix` to the ksuid
that are available at runtime. This generates developer friendly ids much like
stripe's object prefixed ids in your elixir application. (ie:
`"user_2EXfh2MYltdeuaZucgVQAfqgOmt"`)

## Documentation

Documentation can be found online on [HexDocs](https://hexdocs.pm/ecto_ksuid).

## Installation

1. Add `:ecto_ksuid` to your list of dependencies in `mix.exs`

   ```elixir
   def deps do
     [
       # ...
       {:ecto_ksuid, "~> 0.1.0"}
     ]
   end
   ```

2. Add columns to your database

   ```bash
   mix deps.get
   ```

## Basic Usage

`EctoKsuid` is just a custom `Ecto.ParameterizedType` and can be used in your
application just like any other Ecto type.

1. Add columns to your database

   ```elixir
   defmodule MyApp.Repo.Migrations.AddPublicIdToUsers do
     use Ecto.Migration

     def change do
       alter table(:users) do
         add :public_id, EctoKsuid.column()
       end
     end
   end
   ```

2. Add fields to your schema

   ```elixir
   defmodule MyApp.User do
     use Ecto.Schema

     schema "users" do
       # ...
       field :public_id, EctoKsuid
     end
   end
   ```

## Guides

For more details on how to use this library, check out the guides:

- [Using Ksuid as the Default](using_ksuid_as_default.md)
- [Configuring Prefix](configuring_prefix.md)
