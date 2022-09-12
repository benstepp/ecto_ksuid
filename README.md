# ecto_ksuid

[![Build Status](https://github.com/benstepp/ecto_ksuid/actions/workflows/ci.yml/badge.svg)](https://github.com/benstepp/ecto_ksuid/actions)
[![Hex.pm Version](https://img.shields.io/hexpm/v/ecto_ksuid 'hex.pm')](https://hex.pm/ecto_ksuid)
[![Hexdocs](https://img.shields.io/badge/Docs-hexdocs-green 'hexdocs.pm')](https://hexdocs.pm/ecto_ksuid)
[![Downloads](https://img.shields.io/hexpm/dt/ecto_ksuid)](https://hex.pm/ecto_ksuid)
[![License MIT](https://img.shields.io/badge/license-MIT-green 'License MIT')](https://github.com/benstepp/ecto_ksuid/blob/main/LICENSE)

`EctoKsuid` allows seamless usage of
[ksuids](https://github.com/segmentio/ksuid) with `:ecto` in your application.
To get a better idea of what ksuids are, and how they came to be I highly
recommend reading [A breif History of the
UUID](https://segment.com/blog/a-brief-history-of-the-uuid/)

> [Ksuid] borrows core ideas from the ubiquitous UUID standard, adding time-based
> ordering and more friendly representation formats.

Additionally, `EctoKsuid` allows easy addition of a `:prefix` to the ksuid
that are available at runtime. This generates developer friendly ids much like
stripe's object prefixed ids in your elixir application.

#### Example Ksuids using the `"user_"` prefix

- `"user_2EgT2R97RRNXWXdA3Ov6znVLDCd"`
- `"user_2EgT5YAJ1EMj86IdI8In8Cmfsnj"`
- `"user_2EgT6WuSzOmcF9bZaRdS3X6lEaL"`
- `"user_2EgT7SEl7LaIGIHIQ1gIjB9eVwT"`
- `"user_2EgT8B20KvdsIQznKX6Tuh2RGDe"`

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

2. Install using mix.

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
