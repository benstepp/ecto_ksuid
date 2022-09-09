# Configuring a Ksuid Prefix

It may be desirable to add a prefix to your IDs in your application's runtime.
This makes logging and debugging a little more develoer friendly.

Similar to stripe's ids:

* "ch_asdfghjklassdfghjkl"

## Allowed Values

You can use any string you want as the prefix, and it will be injected at
runtime. Only the ksuid is stored in the database columns.

Some valid values:

* `"ch_"`
* `"posts-"`
* `"123"`
* `"long string because it really doesn't matter, but you really shouldn't"`
* `"🐸"`

Yes, if you like frog or have a frog table, you can use frog emojis as a
prefix.

## Examples:

### Configuring a module attribute

```elixir
# lib/my_app/user.ex
defmodule MyApp.User do
  use Ecto.Schema

  @primary_key {:id, Ecto.Ksuid, autogenerate: true, prefix: "user_"}

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
    field :public_id, Ecto.Ksuid, prefix: "post_"
  end
end
```

### Configuring with a base schema module

```elixir
defmodule MyApp.Schema do
  defmacro __using__(opts \\ []) do
    quote do
      use Ecto.Schema

      @primary_key {:id, Ecto.Ksuid, autogenerate: true}
      @foreign_key_type Ecto.Ksuid
    end
  end
end
```
