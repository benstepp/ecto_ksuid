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
