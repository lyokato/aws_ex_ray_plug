defmodule AwsExRayPlugTest do

  use ExUnit.Case
  use Plug.Test

  alias AwsExRay.Test.Router
  import Mox

  use StructAssert

  require Logger

  setup do
    AwsExRay.Test.Mox.setup_default()
    :ok
  end

  @opts Router.init([])

  test "plug aws-ex-ray support" do

    {:ok, agent} = Agent.start_link(fn -> [] end)

    AwsExRay.Client.Sandbox.Sink.Stub
    |> stub(:send, fn data ->

      Agent.update(agent, fn state -> [data|state] end)

    end)

    conn = conn(:get, "/foo")
         |> put_req_header("content-type", "application/json")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    resp = Poison.decode!(conn.resp_body)
    assert resp["body"] == "Hello, Foo"


    [got] = Agent.get(agent, &(&1))
    segment = Poison.decode!(got)

    assert_subset(segment, %{
      "name" => "my-xray",
      "annotations" => %{"foo" => "bar"},
      "metadata" => %{
        "bar" => "buz",
        "tracing_sdk" => %{
          "name" => "aws-ex-ray",
          "version" => "0.0.1"
        }
      },
      "http" => %{
        "request" => %{
          "client_ip" => "127.0.0.1",
          "method" => "GET",
          "url" => "http://www.example.com/foo",
          "x_forwarded_for" => false
        },
        "response" => %{
          "content_length" => 21,
          "status" => 200
        }
      },
    })

  end

end
