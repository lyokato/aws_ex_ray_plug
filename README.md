# AwsExRay - Plug Support

## NOT STABLE YET

Please wait version 1.0.0 released.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aws_ex_ray_plug` to your list of dependencies in `mix.exs`:

```elixir
def application do
  [
    extra_applications: [
      :logger,
      :aws_ex_ray
      # ...
    ],
    mod {MyApp.Supervisor, []}
  ]
end

def deps do
  [
    {:aws_ex_ray, "~> 0.1.0"},
    {:aws_ex_ray_plug, "~> 0.1.0"},
     # ...
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/aws_ex_ray_plug](https://hexdocs.pm/aws_ex_ray_plug).

## USAGE

In your router, set `AwsExRay.Plug`.

```elixir
defmodule MyPlugRouter do

  use Plug.Router

  plug AwsExRay.Plug, name: "my-xray", skip: [{:get, "/bar"}]

  plug :match
  plug :dispatch

  get "/foo" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{body: "Hello, Foo"}))
  end

  get "/bar" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{body: "Hello, Bar"}))
  end

end
```

When new http request comes, and it's **METHOD** and **PATH** pair is not included `:skip` option,
Tracing is automatically started with the name which you passed with `:name` option.

If the incoming request has valid **X-Amzn-Trace-Id** header,
it tries to keep parent **Trace**, or else, it starts a new **Trace**.

## SEE ALSO

- Core: https://github.com/lyokato/aws_ex_ray
- Ecto Support: https://github.com/lyokato/aws_ex_ray_ecto
- HTTPoison Support: https://github.com/lyokato/aws_ex_ray_httpoison
- ExAws Support: https://github.com/lyokato/aws_ex_ray_ex_aws

