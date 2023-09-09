# Configuring a Ksuid Prefix

It may be desirable to add a prefix to your IDs in your application's runtime.
This makes logging and debugging a little more developer friendly.

This is similar to stripe's object prefixed ids:

- `"user_2EgT2R97RRNXWXdA3Ov6znVLDCd"`

## Allowed Values

You can use any string you want as the prefix, and it will be injected at
runtime. Only the ksuid is stored in the database columns.

Some valid values:

- `"ch_"`
- `"posts-"`
- `"123"`
- `"long string because it really doesn't matter, but you really shouldn't"`
- `"🐸"`

Yes, if you like frog or have a frog table, you can use frog emojis as a
prefix.

## Examples:

### Configuring a module attribute

```elixir
# lib/my_app/user.ex
defmodule MyApp.User do
  use Ecto.Schema

  @primary_key {:id, EctoKsuid, autogenerate: true, prefix: "user_"}

  schema "users" do
    # ...
  end
end
```

### Configuring a schema field

```elixir
# lib/my_app/post.ex
defmodule MyApp.Post do
  use Ecto.Schema

  schema "posts" do
    # ...
    field :public_id, EctoKsuid, prefix: "post_"
  end
end
```

### Configuring with a base schema module

```elixir
defmodule MyApp.Schema do
  defmacro __using__(opts \\ []) do
    options = Keyword.merge(opts, autogenerate: true)

    quote do
      use Ecto.Schema

      @primary_key {:id, EctoKsuid, unquote(options)}
      @foreign_key_type EctoKsuid
    end
  end
end

defmodule MyApp.User do
  use MyApp.Schema, prefix: "user_"

  schema "users" do
    # ...
  end
end
```

## Storing the Prefix

It may be desirable to store the configured prefix in the database. By passing
`dump_prefix: true`, the prefix will be included in the stored column.

Note that the column in the database needs to have an appropraite length to
store the prefix. If using the default suggestion of a `char(27)` column, you
won't be able to store a prefix without changing the column type.

> ### Warning {: .warning}
>
> If you decide to change the `prefix`, all existing rows with the old dumped
> prefix will need to be migrated to the new prefix.

### Example

Here the "acct\_" prefix will be saved in the `id` column of the `accounts`
table.

```elixir
# lib/my_app/account.ex
defmodule MyApp.Account do
  use Ecto.Schema

  @primary_key {:id, EctoKsuid, autogenerate: true, prefix: "acct_", dump_prefix: true}

  schema "accounts" do
    # ...
  end
end
```
