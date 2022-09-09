# ecto_ksuid

![License MIT](https://img.shields.io/badge/license-MIT-brightgreen "License MIT")

## Overview

`Ecto.Ksuid` allows seamless usage of ksuids with ecto in your application.

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

## Usage

1. Add columns to your database

    ```elixir
    defmodule MyApp.Repo.Migrations.AddPublicIdToUsers do
      use Ecto.Migration

      def change do
        alter table(:users) do
          add :public_id, Ecto.Ksuid.column()
        end
      end
    end
    ```

2. Add columns to your schema

    ```elixir
    defmodule MyApp.User do
      use Ecto.Schema

      schema "users" do
        # ...
        field :public_id, Ecto.Ksuid
      end
    end
    ```
## Guides

using ksuid as default
